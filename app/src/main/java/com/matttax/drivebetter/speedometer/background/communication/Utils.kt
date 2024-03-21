package com.matttax.drivebetter.speedometer.background.communication

import android.os.Message
import android.os.Messenger
import android.os.RemoteException

fun Messenger.trySend(message: Message) {
    try {
        send(message)
    } catch (ignore: RemoteException) { }
}
