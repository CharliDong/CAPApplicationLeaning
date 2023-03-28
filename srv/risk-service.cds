using { sap.ui.riskmanagement as my } from '../db/schema'; //将schema的命名空间重命名为my

@path: 'service/risk' //url路径
service RiskService { 
  /*
  这段代码定义了一个名为Risks的实体，
  并通过“projection on”关键字将其定义为基于数据库模型my.Risks的投影（projection）。
  注解@odata.draft.enabled表示这个实体支持OData协议的草案版本，
  即可以进行数据修改操作。
  */
  // entity Risks as projection on my.Risks;
  //   annotate Risks with @odata.draft.enabled; 
  // entity Mitigations as projection on my.Mitigations;
  //   annotate Mitigations with @odata.draft.enabled;
  entity Risks @(restrict : [
            {
                grant : [ 'READ' ],
                to : [ 'RiskViewer' ]
            },
            {
                grant : [ '*' ],
                to : [ 'RiskManager' ]
            }
        ]) as projection on my.Risks;
    annotate Risks with @odata.draft.enabled;
  entity Mitigations @(restrict : [
            {
                grant : [ 'READ' ],
                to : [ 'RiskViewer' ]
            },
            {
                grant : [ '*' ],
                to : [ 'RiskManager' ]
            }
        ]) as projection on my.Mitigations;
    annotate Mitigations with @odata.draft.enabled;
}