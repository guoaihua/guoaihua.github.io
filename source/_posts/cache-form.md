---
title: cache-form
date: 2023-03-27 16:22:19
---

## 缓存组件
缓存分为了普通数据缓存与特殊UI交互缓存，其中普通数据缓存使对象来维护
注册时用type来区分不同的数据表单类型
```javascript
/**
 * 区分多个表单类型
 * 定义格式为 合同类型_位置/业务模块名_表单类型（antd/meta）_form
*/
export enum SourceDataType {
  /** 销售首页antd_form */
  CLM_INDEX_ANTD_FORM = 'clm_index_antd_form',
  /** 销售收款条件 */
  CLM_COLLECTIONTERMS_ANTD_FORM = 'clm_collectionTerms_antd_form',
  /** 收入上报 */
  CLM_REPORTEDINCOMES_ANTD_FORM = 'clm_reportedIncomes_antd_form',
  /** 财务结算信息 */
  CLM_FINANCIALSETTLEMENT_ANTD_FORM = 'clm_financialSettlement_antd_form',
  /** 保证金 */
  CLM_CASHDEPOSIT_ANTD_FORM = 'clm_cashDeposit_antd_form',
  /** 客户签约主体 */
  CLM_PROJECTINFO_ANTD_FORM = 'clm_projectInfo_antd_form',
  /** 销售首页meta_form */
  CLM_INDEX_META_FORM = 'clm_index_meta_form',
  /** 合同风险 */
  CLM_RISK_META_FORM = 'clm_risk_meta_form',
  /** 投标风险 */
  CLM_BID_RISK_META_FORM = 'clm_bid_risk_meta_form',
  /** 销售合同内部变更 */
  CLM_INTERNAL_META_FORM = 'clm_internal_meta_form'
}
```
数据跟新时，有可能多个地方同时使用缓存的对象进行了更新。直接修改缓存对象引用类型的值，不要深拷贝，不然可能同时更新时，数据出现覆盖的现象
```javascript
const updateSourceData = (sourceData: SourceData[]) => {
    // 当数据源有变化时，及时缓存数据
    if (!cacheLock) {
      return
    }
    const tempData = cacheData
    _.forEach(sourceData, item => {
    // 判断type中是否含有modal，含有modal为actions类型
      tempData.formValues[item.type] = item.data
    })
    setCacheData({ ...tempData })
  }
```
如果把 const tempData = cacheData 换成 const tempData = _.deepClone(cacheData),
则多个地方的数据修改无法同步，只能保持了最新的一个值。使用引用类型更新时，也要做一个浅拷贝，
防止无法使cacheData触发重新渲染

- 暴露出如下方法
	- addCacheLoader 提供给数据加载器的添加方法
	- updateSourceData 用于数据改变时，将数据同步给缓存组件的方法
	- updateSourceActionFn 用于特殊的ui操作添加方法
	- updateAction 用于ui操作改变时，将ui操作同步给缓存组件的方法 

## 页面流程

### 1、页面加载阶段
a、页面通过 addCacheLoader 载入当前缓存表单的加载器
```javascript
  useEffect(() => {
    addCacheLoader([
      {
        type: SourceDataType.CLM_INDEX_ANTD_FORM,
        loader: form, // antd 表格只传入form
      },
      {
        type: SourceDataType.CLM_CASHDEPOSIT_ANTD_FORM,
        loader: incomeReportAndSettlementRef?.current?.cashDepositForm,
      },
      {
        type: SourceDataType.CLM_COLLECTIONTERMS_ANTD_FORM,
        loader: incomeReportAndSettlementRef?.current?.collectionTermsForm,
      },
      {
        type: SourceDataType.CLM_FINANCIALSETTLEMENT_ANTD_FORM,
        loader: incomeReportAndSettlementRef?.current?.financialSettlementForm,
      },
      {
        type: SourceDataType.CLM_REPORTEDINCOMES_ANTD_FORM,
        loader: incomeReportAndSettlementRef?.current?.reportedIncomesForm,
      },
      {
        type: SourceDataType.CLM_PROJECTINFO_ANTD_FORM,
        loader: projectInfoRef?.current?.customerForm,
      },
      {
        type: SourceDataType.CLM_INDEX_META_FORM,
        loader: setValues,
      },
    ])
  }, [form?.setFieldsValue,
    incomeReportAndSettlementRef,
    projectInfoRef,
    setValues])
```
b、同时注册数据导入监听，当页面相应表单数据变化时，及时更新对应表单缓存。注意，这里的表单信息可能分散在代码各个地方，在根级容器分发注册方法(updateSourceData)即可。
例如，根级元素注册了以下监听
```javascript

  useEffect(() => {
    // 额外收集单独表单维护的数据
    updateSourceData([{
      type: SourceDataType.CLM_INDEX_ANTD_FORM,
      data: form?.getFieldsValue(),
    },
    {
      type: SourceDataType.CLM_INDEX_META_FORM,
      data: values,
    },
    {
      type: SourceDataType.CLM_PROJECTINFO_ANTD_FORM,
      data: projectInfoRef?.current?.customerForm?.getFieldsValue(),
    },
    ])
  }, [
    JSON.stringify(form?.getFieldsValue()),
    values,
    JSON.stringify(projectInfoRef?.current?.customerForm?.getFieldsValue()),
  ])
```
子元素表单注册：
```javascript
  useEffect(() => {
    updateSourceData([
      {
        type: SourceDataType.CLM_COLLECTIONTERMS_ANTD_FORM,
        data: form?.getFieldsValue(),
      },
    ])
  }, [JSON.stringify(form?.getFieldsValue())])
```

### 缓存组件权限判断
父元素的权限获取可能有延迟，loading判断主要接口的加载完成时间，但是审批接口（可能有可能没有）无法判断。有权限的人才开始拉取缓存数据，收集外部缓存数据
- 创建阶段任何人都有缓存权限
- 创建者在草稿阶段
- 审批人在自己的审批节点

### 数据上报
当用户具备缓存权限，且第一次进行了鼠标操作才开始监听操作
```javascript
    const mouseHandler = () => {
      // 含有当前提交版本数据，且缓存开关处于关闭状态
      if (!cacheLock && currentCacheVersion) {
        getCache()
      }
      // 页面有交互了，需要还原状态
      !cacheLock && setCacheLock(true)
    }
```
检测cacheData的变化，最后一次输入停止的时候开始计时30s，提交数据
```javascript
  useEffect(() => {
    console.log('1111', timer)
    // 缓存锁未开启，不进行缓存
    if (!cacheLock) {
      return
    }
    if (timer) {
      clearTimer(timer)
    }
    // 开启缓存，并且到了上报时间，开始上报缓存
    timer = setTimeout(() => {
      setCache()
    }, REPORT_TIME)
  }, [cacheLock, setCache, cacheKey]) // 自动刷新时，页面变了定时器也要刷新
```
### 数据消费
初始化之后通过getCache拉取到数据后，先把数据存储到waitConsumedCacheData中。同时将模块加载器和待消费数据作为依赖添加个处理函数，当任意一个模块同时具备2者时，对数据进行消费，然后清空该数据。完全结束时，该模块的数据应该被清空
```javascript
  useEffect(() => {
    if (waitConsumedCacheData?.formValues && !_.isEmpty(cacheLoader)) {
      try {
        // 全部被消费完了的时候，清空池子
        if (_.isEmpty(waitConsumedCacheData?.formValues)) {
          setWaitConsumedCacheData({
            ...waitConsumedCacheData,
            formValues: undefined,
          })
          return
        }

        // 检测到有action数据，先执行ui操作再加载数据
        if (waitConsumedCacheData?.actions?.length > 0) {
          _.forEach(waitConsumedCacheData?.actions, i => {
            if (actionFn?.[i] && typeof actionFn[i] === 'function') {
              actionFn[i]()
              setActionFn({
                ...actionFn,
                [i]: undefined,
              })
            }
          })
          setWaitConsumedCacheData({
            ...waitConsumedCacheData,
            actions: [],
          })
          return
        }

        _.forOwn(waitConsumedCacheData?.formValues, (value, key) => {
          // 没有加载器的UI数据，也直接返回，等待加载器打开了再加载缓存数据
          if (!cacheLoader[key] || !value) return

          // 格式化数据
          formatDate(waitConsumedCacheData?.formValues, value, key)

          // 需要的表单插入缓存标记
          // 不需要isCached 的无需插入
          if (_.includes([SourceDataType.CLM_INDEX_META_FORM, SourceDataType.CLM_INDEX_ANTD_FORM, SourceDataType.CLM_INTERNAL_META_FORM], key)) {
            value.isCached = true
          }

          // antd_form类型数据，需要额外的绑定
          // 确保传入的是form，而不是form?.setFieldsValue,直接的数据加载器
          if (key?.includes('antd_form') && typeof cacheLoader[key]?.getFieldDecorator === 'function') {
            // antd_form有些表单数据未初始化，先进行手动绑定，再进行赋值
            console.log(key, value)
            bindFieldsDecorator(value, cacheLoader[key])
            cacheLoader[key]?.setFieldsValue(value)
          } else {
            cacheLoader[key](value)
          }
          // 已经加载过的数据，从当前缓存池中删除
          // 后面加载器更新了，数据依然可以从缓存中取出，防止cachedLoaders加载不及时
          // waitConsumedCacheData.formValues[key] = undefined
          delete waitConsumedCacheData.formValues[key]
          setWaitConsumedCacheData(waitConsumedCacheData)
        })
      } catch (e) {
        console.log(e)
      }
    }
  }, [waitConsumedCacheData, cacheLoader, actionFn])
```

问题：
1、使用引用类型更新时，也要做一个浅拷贝，防止无法使cacheData触发重新渲染，为何？
  function 类型更新时，会做一个对比，引用不变，会放弃更新
2、性能如何优化？