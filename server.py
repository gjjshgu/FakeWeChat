
import asyncio
import websockets
import json
import pymysql
from websockets.connection import State
import threading
# import base64
# import os

mutex = threading.Lock()
db = pymysql.connect(host="localhost", user="root",
                         password="123wsnb!", db="mywechat")
cur = db.cursor()
users = {}
messageQueue = {}

def createTable(sql):
    try:
        cur.execute(sql)
    except Exception as e:
        raise e

def isSignUp(account, password):
    sql = "SELECT username FROM users WHERE account = %s AND password = %s"
    try:
        cur.execute(sql, (account, password))
        result = cur.fetchone()
        return result
    except Exception as e:
        raise e

def addFriend(account):
    sql = "SELECT username FROM users WHERE account = %s"
    try:
        cur.execute(sql, account)
        result = cur.fetchone()
        return result
    except Exception as e:
        raise e

async def changeName(account, new):
    sql = "UPDATE users SET username = %s WHERE account = %s"
    try:
        cur.execute(sql, (new, account))
        db.commit()
    except Exception as e:
        raise e

def messageQueueRW(isPush, account, data=None):
    # 加上互斥锁
    mutex.acquire()
    res = None
    if isPush:
        if account in messageQueue:
            messageQueue[account].append(data)
        else:
            messageQueue[account] = [data]
    else:
        if account in messageQueue:
            res = messageQueue.pop(account)
    mutex.release()

    return res


async def echo(websocket, path):
    async for message in websocket:
        data = json.loads(message)
        print(data)
        if data["type"] == "sign_in":
            res = isSignUp(data["account"], data["password"])
            if res is not None:
                account = data["account"]
                sendMessage = {"type": "success",
                               "username": res[0]}
                await websocket.send(json.dumps(sendMessage))
                print("{}已登录".format(account))
                # users[account] = websocket
            else:
                sendMessage = {"type": "sign_in_failed"}
                await websocket.send(json.dumps(sendMessage))
        elif data["type"] == "sign_up":
            res = isSignUp(data["account"], data["password"])
            if res is None:
                sql = "INSERT INTO users(account, password, username) VALUES(%s, %s, %s)"
                try:
                    cur.execute(sql, (data["account"], data["password"], "微信用户"))
                    db.commit()
                    sendMessage = {"type": "success",
                                   "username": "微信用户"}
                    print("微信用户已登录")
                    # users[data["account"]] = websocket
                    await websocket.send(json.dumps(sendMessage))

                except Exception as e:
                    raise e
            else:
                await websocket.send(json.dumps({"type": "sign_up_failed"}))
        elif data["type"] == "add_friend":
            res = addFriend(data["account"])
            if res is not None:
                sendMessage = {"type": "add_friend",
                               "is_success": "yes",
                               "username": res[0],
                               "account": data["account"]}
                try:
                    await websocket.send(json.dumps(sendMessage))
                except Exception as e:
                    raise e
            else:
                await websocket.send(json.dumps({"type": "add_friend_failed"}))
        elif data["type"] == "send_message":
            # 加入消息队列
            account = data["target_account"]
            print(users)
            if account in users:
                ws = users[data["target_account"]]
                if ws.state is State.CLOSED:
                    # 添加到消息队列
                    messageQueueRW(True, account, data)
                else:
                    await ws.send(json.dumps(data))
            else:
                messageQueueRW(True, account, data)
        elif data["type"] == "message_queue":
            account = data["account"]
            users[account] = websocket
            print(users)
            if account in messageQueue:
                mq = messageQueueRW(False, account)
                # print(mq)
                # await asyncio.wait([websocket.send(json.dumps(message)) for message in mq])
                for message in mq:
                    # 同步执行
                    await websocket.send(json.dumps(message))
        elif data["type"] == "change_name":
            await changeName(data["account"], data["name"])

        # await asyncio.wait([user.send(message) for user in users])


if __name__ == '__main__':
    createTable("""
    CREATE TABLE IF NOT EXISTS users(
    account CHAR(20),
    username CHAR(20),
    password CHAR(20))
    """)
    createTable("""
    CREATE TABLE IF NOT EXISTS moments(
    account CHAR(20),
    username CHAR(20),
    text VARCHAR(50),
    text_time CHAR(15))
    """)
    asyncio.get_event_loop().run_until_complete(websockets.serve(echo, 'localhost', 8765))
    asyncio.get_event_loop().run_forever()