package com.babygrowthlog.shared.domain.__test__

import com.babygrowthlog.shared.domain.AuditInfo
import com.babygrowthlog.shared.domain.SleepRecord
import com.babygrowthlog.shared.domain.SleepRules
import com.babygrowthlog.shared.domain.SleepStatus
import kotlinx.datetime.Instant
import kotlin.test.Test
import kotlin.test.assertFalse
import kotlin.test.assertTrue

/**
 * 睡眠规则回归测试，保护 5 小时防呆提示不被后续重构破坏。
 */
class SleepRulesTest {
    @Test
    fun sleepingLongerThanFiveHoursShouldPromptOverflow() {
        val startedAt = Instant.parse("2026-06-18T00:00:00Z")
        val record = sampleSleepRecord(startedAt)
        val now = Instant.parse("2026-06-18T06:00:00Z")

        assertTrue(SleepRules.shouldPromptOverflow(record, now))
    }

    @Test
    fun finishedSleepShouldNotPromptOverflow() {
        val startedAt = Instant.parse("2026-06-18T00:00:00Z")
        val record = sampleSleepRecord(startedAt).copy(status = SleepStatus.FINISHED)
        val now = Instant.parse("2026-06-18T06:00:00Z")

        assertFalse(SleepRules.shouldPromptOverflow(record, now))
    }

    /**
     * 生成测试用睡眠记录，避免每个用例重复无关审计字段。
     */
    private fun sampleSleepRecord(startedAt: Instant): SleepRecord {
        val audit = AuditInfo(
            createdBy = "user-1",
            createdByName = "妈妈",
            createdAt = startedAt,
            updatedBy = "user-1",
            updatedAt = startedAt,
        )

        return SleepRecord(
            id = "sleep-1",
            babyId = "baby-1",
            startedAt = startedAt,
            status = SleepStatus.SLEEPING,
            audit = audit,
        )
    }
}

