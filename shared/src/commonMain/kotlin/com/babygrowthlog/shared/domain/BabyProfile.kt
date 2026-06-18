package com.babygrowthlog.shared.domain

import kotlinx.datetime.LocalDate
import kotlinx.serialization.Serializable

/**
 * 宝宝档案是成长记录的根实体，首版一个家庭空间只绑定一个宝宝。
 */
@Serializable
data class BabyProfile(
    val id: String,
    val nickname: String,
    val birthDate: LocalDate,
    val gender: BabyGender = BabyGender.UNKNOWN,
)

/**
 * 性别字段用于事实记录，不参与任何医疗或发育判断。
 */
@Serializable
enum class BabyGender {
    BOY,
    GIRL,
    UNKNOWN,
}

