<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/KmssConfig/sys/portal/portal.tld" prefix="portal"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>

<template:include ref="default.simple" >
	<template:replace name="title">
		${lfn:message('kms-integral:kmsIntegral.portlet.points.ranking') }
	</template:replace>
	<template:replace name="head">
		<template:super/>
		<script>
			seajs.use(['theme!list','theme!portal','kms/integral/resource/css/index.css']);
		</script>
	</template:replace>
	<template:replace name="body">
		<portal:header var-width="100%" />
		<%--模块筛选 --%>
		<div style="width:90%; width:980px; margin:4px auto 15px auto;">
			<list:criteria id="module_sort" expand="true" multi="true">		
				<list:cri-criterion title="${lfn:message('kms-integral:kmsIntegralCommon.isTime') }" key="time" multi="false">
					<list:box-select>
						<list:item-select cfg-defaultValue="fdWeek" cfg-required="true">
							<ui:source type="Static">
								[{text:"${lfn:message('kms-integral:kmsIntegralCommon.fdWeek') }", value: 'fdWeek'},
								{text:"${lfn:message('kms-integral:kmsIntegralCommon.fdMonth') }", value:'fdMonth'},
								{text:"${lfn:message('kms-integral:kmsIntegralCommon.fdYear') }", value:'fdYear'},
								{text:"${lfn:message('kms-integral:kmsIntegralCommon.fdTotal') }", value:'fdTotal'}]
							</ui:source>
						</list:item-select>
					</list:box-select>
				</list:cri-criterion>
	
				<list:cri-criterion title="${lfn:message('kms-integral:kmsIntegralCommon.isType') }" key="score" multi="false">
					<list:box-select>
						<list:item-select cfg-defaultValue="fdTotalScore" cfg-required="true">
							<ui:source type="Static">
								[{text:"${lfn:message('kms-integral:kmsIntegralCommon.fdTotalScore') }", value: 'fdTotalScore'},
								{text:"${lfn:message('kms-integral:kmsIntegralCommon.fdTotalRiches') }", value:'fdTotalRiches'}]
							</ui:source>
						</list:item-select>
					</list:box-select>
				</list:cri-criterion>
				
				<list:cri-auto modelName="com.landray.kmss.kms.integral.model.KmsIntegralPersonTotal" 
					property="fdPerson"/>
					
				<list:cri-ref ref="criterion.sys.person" key="personIds" title="按人员" multi="true">
				</list:cri-ref>
			</list:criteria>
			<ui:fixed elem=".lui_list_operation"></ui:fixed>
			<%--list视图--%>
			<list:listview id="listview">
				<ui:source type="AjaxJson">
					{url:'/kms/integral/kms_integral_person_total/kmsIntegralPersonTotal.do?method=data'}
				</ui:source>
				<%--列表形式--%>
				<list:colTable layout="sys.ui.listview.columntable" name="columntable">
						<list:col-serial title="${lfn:message('kms-integral:kmsIntegral.fdRank')}" headerStyle="width:10%"/>
						
						<list:col-html title="${lfn:message('kms-integral:kmsIntegralCommon.name')}" style="width:50%;text-align:left" >
							{$
								<div class="lui_integral_item_box">
									<div class="lui_integral_name_single">{%row['name']%}</div>
									<div class="lui_integral_item_detail">
										<img src="{%row['gradeImg']%}"/>
										<div class="lui_integral_item_info">
											<div class="lui_integral_name">{%row['name']%}</div>
											<div>
												{% row['fdDeps']%}
											</div>
											<div>
												<span>{%row['gradeLevel']%}</span>
												<span>{%row['fdGrade']%}</span>		
											</div>
										</div>
									</div>
								</div>
							$}
				  	 	</list:col-html>
				  	 	<list:col-html title="${lfn:message('kms-integral:kmsIntegralCommon.fdTotalScore')}" 
				  	 		style="width:20%" >
							{$
								<span>{%row['fdTotalScore']%}</span>
							$}
				  	 	</list:col-html>
				  	 	<list:col-html title="${lfn:message('kms-integral:kmsIntegralCommon.fdTotalRiches')}" style="width:20%" >
							{$
								<span>{%row['fdTotalRiches']%}</span>
							$}
				  	 	</list:col-html>
				</list:colTable>
			</list:listview> 
		 	<list:paging></list:paging>
	 	</div>
	 	<portal:footer var-width="100%" />
	</template:replace>
</template:include>
