package com.matttax.drivebetter.speedometer.background.protocol.annotations

import androidx.annotation.IntDef
import com.matttax.drivebetter.speedometer.background.protocol.CommunicationProtocol

@Target(AnnotationTarget.TYPE, AnnotationTarget.VALUE_PARAMETER, AnnotationTarget.PROPERTY)
@IntDef(
    CommunicationProtocol.COMMAND_HANDSHAKE,
    CommunicationProtocol.COMMAND_START_RIDE,
    CommunicationProtocol.COMMAND_PAUSE_RIDE,
    CommunicationProtocol.COMMAND_STOP_RIDE
)
@Retention(AnnotationRetention.SOURCE)
annotation class Command
