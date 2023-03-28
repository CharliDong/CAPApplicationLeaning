using RiskService from './risk-service';

//这些文本被SAP Fiori元素用作表单字段和列标题的标签。
annotate RiskService.Risks with {
	title       @title: 'Title';
	prio        @title: 'Priority';
	descr       @title: 'Description';
	miti        @title: 'Mitigation';
	impact      @title: 'Impact';
}

//第二段annotate代码定义了Mitigations实体的元数据，
//包括了ID、description、owner、timeline和risks属性的标签和显示设置。
//这里通过UI.Hidden注解隐藏了ID属性，
//并在UI.Facet中定义了ValueList参数用于展示该实体的一个列表。
//当你在编辑风险应用程序的对象页时，需要以下部分对缓解字段的价值帮助，该字段是可见的。
annotate RiskService.Mitigations with {
	ID @(
		UI.Hidden,
		Common: {
		Text: description
		}
	);
	description  @title: 'Description';
	owner        @title: 'Owner';
	timeline     @title: 'Timeline';
	risks        @title: 'Risks';
}
/*
这定义了工作清单页面的内容，以及当你点击工作清单中的某一行时，你所导航到的对象页面。
HeaderInfo描述了对象的关键信息，这将使对象页在其标题区域显示风险的标题和副标题descr。
SelectionFields部分定义了哪些属性在列表上方的标题栏中作为搜索字段显示。在这种情况下，prio是唯一明确的搜索字段。
工作列表中的列和它们的顺序来自LineItem部分。
虽然在大多数情况下，这些列是由Value: 跟随实体的属性名称定义的，但在prio和影响的情况下，还有Criticality。
现在，你可以忽略它，但要记住它，以防你进入后面的模块。
接下来是Facets部分。
在这种情况下，它定义了对象页面的内容。它只包含一个单一的面，一个参考面，即字段组FieldGroup#Main的参考面。
这个字段组只是显示为一个表单。FieldGroup#Main中的Data数组的属性决定了表单中的字段。
*/
annotate RiskService.Risks with @(
	UI: {
		HeaderInfo: {
			TypeName: 'Risk',
			TypeNamePlural: 'Risks',
			Title          : {
                $Type : 'UI.DataField',
                Value : title
            },
			Description : {
				$Type: 'UI.DataField',
				Value: descr
			}
		},
		SelectionFields: [prio],
		LineItem: [
			{Value: title},
			{Value: miti_ID},
			{
				Value: prio,
				Criticality: criticality
			},
			{
				Value: impact,
				Criticality: criticality
			}
		],
		Facets: [
			{$Type: 'UI.ReferenceFacet', Label: 'Main', Target: '@UI.FieldGroup#Main'}
		],
		FieldGroup#Main: {
			Data: [
				{Value: miti_ID},
				{
					Value: prio,
					Criticality: criticality
				},
				{
					Value: impact,
					Criticality: criticality
				}
			]
		}
	},
) {

};

/*
第四段annotate代码定义了一个miti属性的注解，
用于在Risks实体的UI配置中展示与该实体相关联的Mitigations实体的列表。
这里通过TextArrangement参数将展示的文本设置为description属性的值，
并通过ValueList参数定义了展示列表的名称和集合路径，
以及参数配置用于关联miti_ID和Mitigations实体的ID和description属性。
*/

annotate RiskService.Risks with {
	miti @(
		Common: {
			//show text, not id for mitigation in the context of risks
			Text: miti.description  , TextArrangement: #TextOnly,
			
			//ValueList帮助用户在编辑对象页面时可以选择一个可用的缓解措施。
			ValueList: {
				Label: 'Mitigations',
				CollectionPath: 'Mitigations',
				Parameters: [
					{ $Type: 'Common.ValueListParameterInOut',
						LocalDataProperty: miti_ID,
						ValueListProperty: 'ID'
					},
					{ $Type: 'Common.ValueListParameterDisplayOnly',
						ValueListProperty: 'description'
					}
				]
			}
		}
	);
}
