package com.matttax.drivebetter.speedometer.background.communication

import android.os.*
import com.matttax.drivebetter.speedometer.model.DashboardData
import com.matttax.drivebetter.speedometer.background.protocol.CommunicationProtocol
import com.matttax.drivebetter.speedometer.background.protocol.annotations.Command

class ServiceMessenger(
    commandCallback: ((@Command Int) -> Unit)
) {
    private var sendingMessenger: Messenger? = null
    private val receivingMessenger = Messenger(
        ReplyHandler(
            commandCallback
        ) { messenger ->
            sendingMessenger = messenger
        }
    )

    fun getBinder(): IBinder = receivingMessenger.binder

    fun sendDashboardData(dashboardData: DashboardData) {
        val bundle = Bundle().apply {
            putInt(CommunicationProtocol.REPLY_TYPE_KEY, CommunicationProtocol.REPLY_DASHBOARD)
            putParcelable(CommunicationProtocol.SEND_DASHBOARD_DATA_KEY, dashboardData)
        }
        sendMessage(bundle)
    }

    fun sendRaceFinished(raceId: Long?) {
        val bundle = Bundle().apply {
            putInt(CommunicationProtocol.REPLY_TYPE_KEY, CommunicationProtocol.REPLY_RACE_FINISH)
            putLong(CommunicationProtocol.SEND_RIDE_ID_KEY, raceId ?: -1L)
        }
        sendMessage(bundle)
    }

    private fun sendMessage(bundle: Bundle) {
        val msg = Message.obtain().apply {
            data = bundle
            replyTo = receivingMessenger
        }
        sendingMessenger?.trySend(msg)
    }

    internal class ReplyHandler(
        private val commandCallback: ((@Command Int) -> Unit),
        private val replyReceiverCallback: ((replyMessenger: Messenger?) -> Unit)
    ) : Handler(Looper.getMainLooper()) {

        override fun handleMessage(message: Message) {
            super.handleMessage(message)
            val command = message.data?.getInt(CommunicationProtocol.COMMAND_TYPE_KEY)
            replyReceiverCallback.invoke(message.replyTo)
            command?.let {
                commandCallback(command)
            }
        }
    }
}
