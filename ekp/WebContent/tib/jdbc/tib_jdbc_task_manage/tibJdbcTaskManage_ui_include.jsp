<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include file="/tib/common/tib_ui_list.jsp">
	<template:replace name="title">${ lfn:message('tib-common:module.tib.manage') }</template:replace>
	<template:replace name="path">
		<ui:combin ref="menu.path.tib.simplecategory">
			<ui:varParams 
				id="simplecategoryId"
				moduleTitle="${ lfn:message('tib-jdbc:module.tib.jdbc') }" 
				cateTitle="${ lfn:message('tib-jdbc:table.tibJdbcTaskCategory') }" 
				href="javascript:parent.tibLoadList('/tib/jdbc/tib_jdbc_task_manage/tibJdbcTaskManage_ui_include.jsp?categoryId=!{value}');" 
				modelName="com.landray.kmss.tib.jdbc.model.TibJdbcTaskCategory" 
				categoryId="${param.categoryId }" />
		</ui:combin>
	</template:replace>
	
	<%-- 右边框内容 --%>
	<template:replace name="content">
		<%-- 筛选器 --%>
		<list:criteria>
			<list:cri-ref key="fdSubject" ref="criterion.sys.docSubject">
			</list:cri-ref>
			<list:cri-ref ref="criterion.sys.simpleCategory" key="docCategory" multi="false" title="分类导航" expand="true">
			  <list:varParams modelName="com.landray.kmss.tib.jdbc.model.TibJdbcTaskCategory"/>
			</list:cri-ref>
			<list:cri-auto modelName="com.landray.kmss.tib.jdbc.model.TibJdbcTaskManage" property="fdIsEnabled"/>
		</list:criteria>
		
		<%-- 显示列表按钮行 --%>
		<div class="lui_list_operation">
			<table width="100%">
				<tr>
					<td align="right">
						<ui:toolbar>
							<kmss:auth requestURL="/tib/jdbc/tib_jdbc_task_manage/tibJdbcTaskManage.do?method=add">
								<ui:button text="${lfn:message('button.add')}" onclick="addDocByCate();" order="2" ></ui:button>
							</kmss:auth>
							<kmss:auth requestURL="/tib/jdbc/tib_jdbc_task_manage/tibJdbcTaskManage.do?method=deleteall">
								<ui:button text="${lfn:message('button.delete')}" order="4" onclick="delDoc('${LUI_ContextPath}/tib/jdbc/tib_jdbc_task_manage/tibJdbcTaskManage.do?method=deleteall')"></ui:button>
							</kmss:auth>
							<kmss:auth requestURL="/tib/jdbc/tib_jdbc_task_manage/tibJdbcTaskManage.do?method=chgenabled">
								<ui:button text="${lfn:message('sys-quartz:sysQuartzJob.button.enable')}"
									onclick="tibEnableSave('${LUI_ContextPath}/tib/jdbc/tib_jdbc_task_manage/tibJdbcTaskManage.do?method=chgenabled&fdIsEnabled=true');"></ui:button>
							</kmss:auth>	
							<kmss:auth requestURL="/tib/jdbc/tib_jdbc_task_manage/tibJdbcTaskManage.do?method=chgenabled">
								<ui:button text="${lfn:message('sys-quartz:sysQuartzJob.button.disable')}"
									onclick="tibEnableSave('${LUI_ContextPath}/tib/jdbc/tib_jdbc_task_manage/tibJdbcTaskManage.do?method=chgenabled&fdIsEnabled=false');"></ui:button>
							</kmss:auth>
						</ui:toolbar>						
					</td>
				</tr>
			</table>
		</div>
		<ui:fixed elem=".lui_list_operation"></ui:fixed>
		<list:listview id="listview">
			<ui:source type="AjaxJson">
				{url:'/tib/jdbc/tib_jdbc_task_manage/tibJdbcTaskManageIndex.do?method=list'}
			</ui:source>
			<%--列表形式--%>
			<list:colTable isDefault="false" layout="sys.ui.listview.columntable" 
				rowHref="/tib/jdbc/tib_jdbc_task_manage/tibJdbcTaskManage.do?method=view&fdId=!{fdId}" name="columntable">
				<list:col-checkbox></list:col-checkbox>
				<list:col-serial></list:col-serial>
				<list:col-auto props=""></list:col-auto>
			</list:colTable>   
		</list:listview> 
		<script type="text/javascript">
		seajs.use(['lui/jquery', 'lui/util/str', 'lui/dialog','lui/topic'], function($, strutil, dialog , topic) {
			var cateId = "${param.categoryId}";
			window.addDocByCate = function(){
				parent.addDoc('${LUI_ContextPath}/tib/jdbc/tib_jdbc_task_manage/tibJdbcTaskManage.do?method=add&fdtemplatId='+ cateId);
			};
			//根据筛选器分类异步校验权限
			topic.subscribe('criteria.changed',function(evt){
				//每次都重置分类id的值,因为可能存在直接点叉清除分类筛选项
				cateId = parent.getCateId(evt, cateId);
			});
		 	//删除
	 		window.delDoc = function(url){
	 			var values = [];
				$("input[name='List_Selected']:checked").each(function(){
					values.push($(this).val());
				});
				if(values.length==0){
					dialog.alert('<bean:message key="page.noSelect"/>');
					return;
				}
				dialog.confirm('<bean:message key="page.comfirmDelete"/>',function(value){
					if(value==true){
						window.del_load = dialog.loading();
						$.post('<c:url value="'+ url +'"/>',
								$.param({"List_Selected":values},true),delCallback,'json');
					}
				});
			};
			window.delCallback = function(data){
				if(window.del_load!=null) {
					window.del_load.hide();
				}
				if(data!=null && data.status==true){
					topic.publish("list.refresh");
					dialog.success('<bean:message key="return.optSuccess" />');
				}else{
					dialog.failure('<bean:message key="return.optFailure" />');
				}
			};
			// 启用/禁用
			window.tibEnableSave = function(url){
				var values = [];
				$("input[name='List_Selected']:checked").each(function(){
					values.push($(this).val());
				});
				if(values.length==0){
					dialog.alert('<bean:message key="page.noSelect"/>');
					return false;
				}
				dialog.confirm('是否确认当前操作?',function(value){
					if(value==true){
						window.del_load = dialog.loading();
						$.post('<c:url value="'+ url +'"/>',
								$.param({"List_Selected":values},true),enableCallback,'json');
					}
				});
				return null;
			};
			window.enableCallback = function(data){
				if(window.del_load!=null) {
					window.del_load.hide();
				}
				if(data!=null && data.status==true){
					topic.publish("list.refresh");
					dialog.success('<bean:message key="return.optSuccess" />');
				}else{
					dialog.failure('<bean:message key="return.optFailure" />');
				}
			};
	 	});
		</script>
		<br>
	 	<list:paging></list:paging>
	</template:replace>
</template:include>