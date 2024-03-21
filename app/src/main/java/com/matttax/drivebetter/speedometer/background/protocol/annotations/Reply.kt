package com.matttax.drivebetter.speedometer.background.protocol.annotations

import androidx.annotation.IntDef
import com.matttax.drivebetter.speedometer.background.protocol.CommunicationProtocol

@IntDef(CommunicationProtocol.REPLY_DASHBOARD, CommunicationProtocol.REPLY_RACE_FINISH)
@Retention(AnnotationRetention.SOURCE)
annotation class Reply
