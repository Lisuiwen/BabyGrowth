package com.babygrowthlog.shared.domain

import kotlinx.datetime.Instant
import kotlin.time.Duration.Companion.hours

/**
 * 睡眠业务规则集中在 shared，确保 Android、后端和未来 iOS 的判断一致。
 */
object SleepRules {
    private val overflowThreshold = 5.hours

    /**
     * 判断“正在睡”是否超过弱提示阈值，只提示修正，不自动替用户结束记录。
     */
    fun shouldPromptOverflow(record: SleepRecord, now: Instant): Boolean {
        if (record.status != SleepStatus.SLEEPING) return false
        return now - record.startedAt > overflowThreshold
    }
}

