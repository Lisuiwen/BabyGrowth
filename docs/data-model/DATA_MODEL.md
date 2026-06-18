# Data Model

## BabyProfile

宝宝档案根实体，首版一个家庭空间只包含一个宝宝。

## FeedingRecord

喂养记录只记录实际发生的方式。混合喂养不作为独立表单，而是在统计层聚合判定。

## SleepRecord

睡眠记录支持 `SLEEPING` 和 `FINISHED`。正在睡超过 5 小时只触发弱提示，不自动改写用户事实。

