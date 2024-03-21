package com.matttax.drivebetter.speedometer.background.communication

import android.os.*
import com.matttax.drivebetter.speedometer.model.DashboardData
import com.matttax.drivebetter.speedometer.background.protocol.annotations.Command
import com.matttax.drivebetter.speedometer.background.protocol.CommunicationProtocol

class ActivityMessenger(
    onStatusUpdated: (dashboardData: DashboardData) -> Unit,
    onFinished: (id: Long) -> Unit = { }
) {
    private var sendingMessenger: Messenger? = null
    private val receivingMessenger = Messenger(
        ReplyHandler(onStatusUpdated, onFinished)
    )

    fun onConnect(messenger: Messenger) {
        this.sendingMessenger = messenger
    }

    fun onDisconnect() {
        this.sendingMessenger = null
    }

    fun startDrive() {
        sendMessage(CommunicationProtocol.COMMAND_START_RIDE)
    }

    fun pauseDrive() {
        sendMessage(CommunicationProtocol.COMMAND_PAUSE_RIDE)
    }

    fun stopDrive() {
        sendMessage(CommunicationProtocol.COMMAND_STOP_RIDE)
    }

    fun handShake() {
        sendMessage(CommunicationProtocol.COMMAND_HANDSHAKE)
    }

    private fun sendMessage(@Command command: Int) {
        val msg = Message.obtain().apply {
            data = Bundle().apply {
                putInt(CommunicationProtocol.COMMAND_TYPE_KEY, command)
            }
            replyTo = receivingMessenger
        }
        sendingMessenger?.trySend(msg)
    }

    internal class ReplyHandler(
        private val onStatusUpdated: (dashboardData: DashboardData) -> Unit,
        private val onRaceFinished: (raceId: Long) -> Unit
    ) : Handler(Looper.getMainLooper()) {

        override fun handleMessage(message: Message) {
            super.handleMessage(message)
            when (message.data?.getInt(CommunicationProtocol.REPLY_TYPE_KEY)) {
                CommunicationProtocol.REPLY_DASHBOARD -> {
                    val dashboardData =
                        message.data?.getParcelable<DashboardData>(CommunicationProtocol.SEND_DASHBOARD_DATA_KEY)
                            ?: return
                    onStatusUpdated.invoke(dashboardData)
                }
                CommunicationProtocol.REPLY_RACE_FINISH -> {
                    val raceId = message.data?.getLong(CommunicationProtocol.SEND_RIDE_ID_KEY)
                    raceId?.let {
                        onRaceFinished(it)
                    }
                }
            }
        }
    }
}
