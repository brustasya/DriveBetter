package com.matttax.drivebetter.speedometer.background.protocol

object CommunicationProtocol {
    const val SEND_DASHBOARD_DATA_KEY = "dashboard_data"
    const val SEND_RIDE_ID_KEY = "race_id"

    const val COMMAND_TYPE_KEY = "command_type"
    const val REPLY_TYPE_KEY = "reply_type"

    const val COMMAND_HANDSHAKE = 0
    const val COMMAND_START_RIDE = 3
    const val COMMAND_PAUSE_RIDE = 4
    const val COMMAND_STOP_RIDE = 5

    const val REPLY_DASHBOARD = 1
    const val REPLY_RACE_FINISH = 2
}
