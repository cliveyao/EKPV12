<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<%@page import="java.util.List"%>
<template:include ref="default.view"   sidebar="auto"> 
	<template:replace name="head">
	<style type="text/css">
	.titleDiv{
			height: 25px;
			border-bottom: 2px;
			border-bottom-style: dotted;
			border-bottom-color: rgb(240, 20, 87);
			font-family:Microsoft YaHei, Geneva, "sans-serif", SimSun;
			font-size: 14px;
			font-weight: bold
		}
		@media print {
			#btnDiv{
				display: none;
			}
			#toolBarDiv{
				display: none;
			}
		}
	</style>
	</template:replace>
	<template:replace name="title">
		<c:out value="${ kmImissiveSendMainForm.docSubject } - ${ lfn:message('km-imissive:module.km.imissive') }"></c:out> 
	</template:replace>
	<template:replace name="toolbar">
<%
	//out.print(request.getHeader("User-Agent"));
	if(request.getHeader("User-Agent").toUpperCase().indexOf("MSIE")>-1){
		request.setAttribute("isIE",true);
	}else if(request.getHeader("User-Agent").toUpperCase().indexOf("TRIDENT")>-1){
		request.setAttribute("isIE",true);
	}else{
		request.setAttribute("isIE",false);
	}
%>
<script>
function changeValue(obj){
	if(obj.checked){
      $("#"+obj.id+"Div").show();
	}else{
		$("#"+obj.id+"Div").hide();
	}
}
seajs.use(['lui/jquery'], function($) {
	$(document).ready(function(){
	$("#attDiv").hide();
	$("#wflogDiv").hide();
	$("#circulationDiv").hide();
	$("#readlogDiv").hide();
	$("#publiclogDiv").hide();
	});
});
</script>
<div id="btnDiv">
	<ui:toolbar  id="toolbar" layout="sys.ui.toolbar.float" count="3">
	    <ui:button text="${ lfn:message('button.print') }"   onclick="window.print();">
	    </ui:button>
		<ui:button text="${lfn:message('button.close')}" order="5" onclick="Com_CloseWindow();">
		</ui:button>
	</ui:toolbar>
</div>
	</template:replace>
	<template:replace name="content"> 
<div id="toolBarDiv" style="padding-top: 12px;">
	 <table class="tb_normal"  width=98%>
		<tr>
			<td>
				<label>
				<input  id="att" type="checkbox" onclick="changeValue(this);"/>
				 附件
				</label>
			</td>
			<kmss:auth requestURL="/km/imissive/km_imissive_receive_main/kmImissiveReceiveMain.do?method=readViewLog&fdId=${param.fdId}" requestMethod="GET">
			<td>
				<label>
				<input id="wflog" type="checkbox" onclick="changeValue(this);"/>
				 审批记录
				</label>
			</td>
			</kmss:auth>
			<c:if test="${kmImissiveReceiveMainForm.docStatus eq '30'}">
				<td>
					<label>
					<input id="circulation" type="checkbox" onclick="changeValue(this);"/>
					传阅
					</label>
				</td>
			</c:if>
			<td>
				<label>
				<input id="readlog" type="checkbox" onclick="changeValue(this);"/>
				 阅读记录
				</label>
			</td>
			<c:if test="${kmImissiveReceiveMainForm.docStatus eq '30'}">
				<td>
					<label>
					<input id="publiclog" type="checkbox" onclick="changeValue(this);"/>
					 发布记录
					</label>
				</td>
			</c:if>
		</tr>
	</table>
</div>
	    <div class="lui_form_content_frame" style="padding-top:10px">
	    <table   width=100% style="margin-top: 20px;">
			<tr>
				<td colspan="4">
				 <c:import url="/sys/xform/include/sysForm_view.jsp"	charEncoding="UTF-8">
					<c:param name="formName" value="kmImissiveReceiveMainForm" />
					<c:param name="fdKey" value="receiveMainDoc" />
					<c:param name="messageKey" value="km-imissive:kmImissiveSendMain.baseinfo"/>
					<c:param name="useTab" value="false"/>
				</c:import>
				</td>
			</tr>
		</table>
		</div>
		<div class="lui_form_content_frame" style="padding-top:10px" id="attDiv">
		<div class="titleDiv"><img src="${KMSS_Parameter_ContextPath}third/pda/resource/images/attachment.png">正文附件</div>
	    <table     width=100% style="margin-top: 20px;">
			<tr>
				<td class="td_normal_title" width="15%"><bean:message bundle="km-imissive" key="kmImissiveSendMain.attachement" /></td>
				<td colspan="3">
					<c:import url="/sys/attachment/sys_att_main/sysAttMain_view.jsp" charEncoding="UTF-8">
						<c:param
							name="fdKey"
							value="attachment" />
						<c:param
							name="formBeanName"
							value="kmImissiveReceiveMainForm" />
					</c:import>
				</td>
			</tr>
		</table>
		</div>
		<kmss:auth requestURL="/km/imissive/km_imissive_receive_main/kmImissiveReceiveMain.do?method=readViewLog&fdId=${param.fdId}" requestMethod="GET">
		<div class="lui_form_content_frame" style="padding-top:10px" id="wflogDiv">
	    <div class="titleDiv">审批记录</div>
	    <table     width=100% style="margin-top: 20px;">
			<tr>
				<td colspan="4">
				   <c:import url="/sys/workflow/include/sysWfProcess_log.jsp" charEncoding="UTF-8">
						<c:param name="formName" value="kmImissiveReceiveMainForm" />
					</c:import>
				</td>
			</tr>
		</table>
		</div>
		</kmss:auth>
		<c:if test="${kmImissiveReceiveMainForm.docStatus eq '30'}">
		<div class="lui_form_content_frame" style="padding-top:10px" id="circulationDiv">
		<div class="titleDiv"> 传阅</div>
	    <table     width=100% style="margin-top: 20px;">
			<tr>
				<td colspan="4">
					 <c:import
						url="/km/imissive/import/sysCirculationMain_viewPrint.jsp"
						charEncoding="UTF-8">
						<c:param
							name="formName"
							value="kmImissiveReceiveMainForm" />
					</c:import>
				</td>
			</tr>
		</table>
		</div>
		</c:if>
		 <div class="lui_form_content_frame" style="padding-top:10px" id="readlogDiv">
		 <div class="titleDiv">阅读记录</div>
	     <table     width=100% style="margin-top: 20px;">
			<tr>
				<td colspan="4">
				  <c:import url="/km/imissive/import/sysReadLog_viewPrint.jsp" charEncoding="UTF-8">
					<c:param name="formName" value="kmImissiveReceiveMainForm" />
			      </c:import>
				</td>
			</tr>
		 </table>
		 </div>
		 <c:if test="${kmImissiveReceiveMainForm.docStatus eq '30'}">
		 <div class="lui_form_content_frame" style="padding-top:10px" id="publiclogDiv">
		 <div class="titleDiv">发布记录</div>
	     <table     width=100% style="margin-top: 20px;">
			<tr>
				<td colspan="4">
				<c:import url="/km/imissive/import/sysNewsPublishMain_viewPrint.jsp" charEncoding="UTF-8">
					<c:param name="formName" value="kmImissiveReceiveMainForm" />
					<c:param name="fdKey" value="receiveMainDoc" />
			    </c:import>
				</td>
			</tr>
		 </table>
		 </div>
		 </c:if>
</template:replace>
</template:include>
