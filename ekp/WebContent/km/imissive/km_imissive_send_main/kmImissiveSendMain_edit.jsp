<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/sys/ui/jsp/common.jsp"%>
<template:include ref="default.edit"  sidebar="auto">
<%@ page import="com.landray.kmss.util.IDGenerator"%>
<%@page import="com.landray.kmss.km.imissive.util.KmImissiveConfigUtil"%>
		<template:replace name="toolbar">
		<%@ include file="/km/imissive/script.jsp"%>
		<%@ include file="/km/imissive/km_imissive_send_main/script.jsp"%>
		<ui:toolbar id="toolbar" layout="sys.ui.toolbar.float"> 
			<c:if test="${kmImissiveSendMainForm.method_GET=='add'}">
			    <ui:button text="${lfn:message('button.savedraft') }" order="2" onclick="commitMethod('save','true');">
				</ui:button>
				<ui:button text="${lfn:message('button.submit') }" order="2" onclick=" commitMethod('save','false');">
				</ui:button>
			</c:if>
			<%-- 套红附加选项 --%>
			<c:if  test="${kmImissiveSendMainForm.sysWfBusinessForm.fdNodeAdditionalInfo.redhead =='true'}">
			   <ui:button text="${lfn:message('km-imissive:kmImissive.redhead') }" order="2"
			     onclick="LoadHeadWordList('com.landray.kmss.km.imissive.model.KmImissiveSendMain');">
			   </ui:button>
			</c:if>
			<%-- 文件编号附加选项 --%>
			<c:if  test="${kmImissiveSendMainForm.sysWfBusinessForm.fdNodeAdditionalInfo.modifyDocNum =='true'}">
			    <ui:button text="${lfn:message('km-imissive:kmImissive.modifyDocNum') }" order="3"
					 onclick="generateFileNum();">
				</ui:button>
			</c:if>
			<c:if test="${kmImissiveSendMainForm.method_GET=='edit'}">
				<c:if test="${kmImissiveSendMainForm.docStatus=='10'}">
					<ui:button text="${lfn:message('button.savedraft') }" order="2" onclick=" commitMethod('update','true');">
					</ui:button>
				</c:if>
				<c:if test="${kmImissiveSendMainForm.docStatus<'20'}">
				    <ui:button text="${lfn:message('button.submit') }" order="2" onclick=" commitMethod('update','false');">
					</ui:button>
				</c:if>
				<c:if test="${kmImissiveSendMainForm.docStatus=='20'}">
				    <ui:button text="${lfn:message('button.submit') }" order="2" onclick=" Com_Submit(document.kmImissiveSendMainForm, 'update');">
					</ui:button>
				</c:if>
				<c:if test="${kmImissiveSendMainForm.docStatus>='30'}">
				    <ui:button text="${lfn:message('button.submit') }" order="2" onclick=" Com_Submit(document.kmImissiveSendMainForm, 'update');">
					</ui:button>
				</c:if>
			 </c:if>
			 <ui:button text="${ lfn:message('button.close') }" order="5"  onclick="Com_CloseWindow()">
			 </ui:button>
			</ui:toolbar>
		</template:replace>
		<template:replace name="path">
		<ui:menu layout="sys.ui.menu.nav"  id="categoryId"> 
			<ui:menu-item text="${ lfn:message('home.home') }" icon="lui_icon_s_home"></ui:menu-item>
			<ui:menu-item text="${ lfn:message('km-imissive:module.km.imissive') }" ></ui:menu-item>
			<ui:menu-item text="${ lfn:message('km-imissive:kmImissive.nav.SendManagement') }"></ui:menu-item>
			<ui:menu-source autoFetch="false">
				<ui:source type="AjaxJson">
					{"url":"/sys/category/criteria/sysCategoryCriteria.do?method=path&modelName=com.landray.kmss.km.imissive.model.KmImissiveSendTemplate&categoryId=${kmImissiveSendMainForm.fdTemplateId}"} 
				</ui:source>
			</ui:menu-source>
		</ui:menu>
		</template:replace>
	<template:replace name="content"> 
	<c:if test="${kmImissiveSendMainForm.method_GET=='add'}">
			<script type="text/javascript">
				window.changeDocTemp = function(modelName,url,canClose){
					if(modelName==null || modelName=='' || url==null || url=='')
						return;
			 		seajs.use(['sys/ui/js/dialog'],function(dialog) {
					 	dialog.categoryForNewFile(modelName,url,false,null,function(rtn) {
							// 无分类状态下（一般于门户快捷操作）创建文档，取消操作同时关闭当前窗口
							if (!rtn)
								window.close();
						},'${param.categoryId}','_self',canClose);
				 	});
			 	};
			 	
				if('${param.fdTemplateId}'==''){
					window.changeDocTemp('com.landray.kmss.km.imissive.model.KmImissiveSendTemplate','/km/imissive/km_imissive_send_main/kmImissiveSendMain.do?method=add&fdTemplateId=!{id}&fdTemplateName=!{name}&fdModelId=${param.fdModelId}&fdModelName=${param.fdModelName}',true);
				}
			</script>
	</c:if>
	<%
	 //生成一个附件id,供原始稿上传用
	  request.setAttribute("attId",IDGenerator.generateID());
	%>
	<script>
	    Com_IncludeFile("dialog.js|jquery.js");
	</script>
	<script language="JavaScript">
	   function saveAttTrack(fdFileId,fdFileName,type,fdNodeName){
		   var flag = false;
		   var url="${KMSS_Parameter_ContextPath}km/imissive/km_imissive_send_main/kmImissiveSendMain.do?method=addAttTrack"; 
		   $.ajax({     
	  	     type:"post",     
	  	     url:url,     
	  	     data:{fdMainId:"${kmImissiveSendMainForm.fdId}",type:type,fdFileId:fdFileId,fdFileName:fdFileName,fdNodeName:fdNodeName},    
	  	     async:false,    //用同步方式 
	  	     success:function(){
	  	    	flag = true;
	  		 }    
	      });
		   return flag;
	   }
	function commitMethod(commitType, saveDraft){
		if($KMSSValidation(document.forms['kmImissiveSendMainForm']).validate()){
			var formObj = document.kmImissiveSendMainForm;
			var docStatus = document.getElementsByName("docStatus")[0];
			if(saveDraft=="true"){
				docStatus.value="10";
			}else{
				docStatus.value="20";
			}
			var del = true;
			var fdNumberMainId = document.getElementsByName("fdNumberMainId");
			if(fdNumberMainId.length>0){
				if(fdNumberMainId[0].value==""){
					del = confirm("您要提交的文件，没有设置编号规则，是否继续提交？");
				}
			}
			if(del){
			  Com_Submit(formObj, commitType);
			  //删除cookie,避免新建每次取到同一编号
			  if("${fdNoId}"!=""){
				  delCookieByName("${fdNoId}");
		      }
			}
		}
	}
	// 还原特殊符号
	function returnContent(){
		var fdContent = document.getElementsByName('fdContent')[0].value;
		var docSubject = document.getElementsByName('docSubject')[0].value;
		fdContent = returnStr(fdContent);
		docSubject = returnStr(docSubject);
		document.getElementsByName('fdContent')[0].value = fdContent;
		document.getElementsByName('docSubject')[0].value = docSubject;
	}
	//解决非ie下控件高度问题
	$(document).ready(function(){
		var obj = document.getElementById("JGWebOffice_editonline");
		if(obj){
			obj.setAttribute("height", "550px");
		}
	});
	</script>
		<html:form action="/km/imissive/km_imissive_send_main/kmImissiveSendMain.do">
		    <html:hidden property="docStatus" />
			<html:hidden property="fdId"/>
			<html:hidden property="fdModelId" />
			<html:hidden property="fdModelName"/>
		     <kmss:showWfPropertyValues  var="nodevalue" idValue="${kmImissiveSendMainForm.fdId}" propertyName="nodeName" />
			<div class="lui_form_content_frame" style="padding-top: 5px">
				<c:import url="/sys/xform/include/sysForm_edit.jsp"
					charEncoding="UTF-8">
					<c:param name="formName" value="kmImissiveSendMainForm" />
					<c:param name="fdKey" value="sendMainDoc"/>
					<c:param name="messageKey" value="km-imissive:kmImissiveSendMain.baseinfo"/>
					<c:param name="useTab" value="false" />
				</c:import>
			</div>
			<div class="lui_form_content_frame" style="padding-top:10px">
				<div class="lui_form_spacing"></div> 
				<div>
					<div class="lui_form_subhead"><img src="${KMSS_Parameter_ContextPath}sys/attachment/view/img/attachment.png"> ${ lfn:message('sys-doc:sysDocBaseInfo.docAttachments') }</div>
				    <c:import
						url="/sys/attachment/sys_att_main/sysAttMain_edit.jsp"
						charEncoding="UTF-8">
						<c:param name="fdKey" value="attachment" />
						<c:param name="fdModelId" value="${param.fdId }"/>
						<c:param name="fdModelName"
							value="com.landray.kmss.km.imissive.model.KmImissiveSendMain" />
					</c:import>
				</div> 	
		   </div>
			<ui:tabpage expand="false">
				<ui:content title="正文" expand="false">
				<%-- --套红头 -- --%>
				<%@ include file="/km/imissive/kmImissiveRedhead_script.jsp"%>
				<%@ include file="/km/imissive/km_imissive_send_main/kmImissiveSendRedhead_script.jsp"%>
				<table class="tb_normal" width="100%">
				<tr>
					<td colspan="4">
					<div id="missiveButtonDiv" style="text-align: right; padding-bottom: 5px">&nbsp; 
						<a href="javascript:void(0);" class="attbook"
						   onclick="Com_OpenWindow(Com_Parameter.ContextPath+'km/imissive/km_imissive_send_main/bookMarks.jsp','_blank');">
					     <bean:message key="kmImissive.bookMarks.title" bundle="km-imissive" />
					     </a>
					</div>
					   <%
							// 金格启用模式
							if(com.landray.kmss.sys.attachment.util.JgWebOffice.isJGEnabled()) {
								pageContext.setAttribute("sysAttMainUrl", "/sys/attachment/sys_att_main/jg/sysAttMain_edit.jsp");
							}
						%> <c:import url="${sysAttMainUrl}" charEncoding="UTF-8">
						<c:param name="fdKey" value="editonline" />
						<c:param name="fdAttType" value="office" />
						<c:param name="fdModelId" value="${kmImissiveSendMainForm.fdId}" />
						<c:param name="fdModelName"
							value="com.landray.kmss.km.imissive.model.KmImissiveSendMain" />
						<c:param name="fdTemplateModelId"
							value="${kmImissiveSendMainForm.fdTemplateId}"/>
						<c:param name="fdTemplateModelName"
							value="com.landray.kmss.km.imissive.model.KmImissiveSendTemplate" />
						<c:param name="fdTemplateKey" value="editonline" />
						<c:param name="templateBeanName" value="kmImissiveSendTemplateForm" />
						<c:param name="buttonDiv" value="missiveButtonDiv" />
						<c:param name="isToImg" value="false"/>
						<c:param name="bookMarks"
							value="docsubject:${kmImissiveSendMainForm.docSubject},doctype:${kmImissiveSendMainForm.fdDocTypeName},sendunit:${kmImissiveSendMainForm.fdSendtoUnitName},docnum:${kmImissiveSendMainForm.fdDocNum},secretgrade:${kmImissiveSendMainForm.fdSecretGradeName},checker:${kmImissiveSendMainForm.fdCheckerName},emergency:${kmImissiveSendMainForm.fdEmergencyGradeName},signature:${kmImissiveSendMainForm.fdSignatureName},draftunit:${kmImissiveSendMainForm.fdDraftUnitName},drafter:${kmImissiveSendMainForm.fdDrafterName},drafttime:${kmImissiveSendMainForm.fdDraftTime},content:${kmImissiveSendMainForm.fdContent},signdatecn:${kmImissiveSendMainForm.docPublishTimeUpper},signdate:${kmImissiveSendMainForm.docPublishTimeNum},printnum:${kmImissiveSendMainForm.fdPrintNum},printpagenum:${kmImissiveSendMainForm.fdPrintPageNum},copytounit:${kmImissiveSendMainForm.fdMissiveCopytoNames},maintounit:${kmImissiveSendMainForm.fdMissiveMaintoNames},reporttounit:${kmImissiveSendMainForm.fdMissiveReporttoNames}" />
                        </c:import></td>
				   </tr>
			    </table>
				</ui:content>
				<!-- 以下代码为嵌入流程模板标签的代码 -->
				<c:import url="/sys/workflow/import/sysWfProcess_edit.jsp"
					charEncoding="UTF-8">
					<c:param name="formName" value="kmImissiveSendMainForm" />
					<c:param name="fdKey" value="sendMainDoc" />
					<c:param name="showHistoryOpers" value="true" />
				</c:import>
				<!-- 以上代码为嵌入流程模板标签的代码 -->
				<!--发布机制开始-->
				<c:import url="/sys/news/import/sysNewsPublishMain_edit.jsp"
					charEncoding="UTF-8">
					<c:param name="formName" value="kmImissiveSendMainForm" />
					<c:param name="fdKey" value="sendMainDoc" />
					<c:param name="isShow" value="true" />
				</c:import>
				<!--发布机制结束-->
				<!-- 权限机制  -->
				<ui:content title="${ lfn:message('sys-right:right.moduleName') }">
					<table class="tb_normal" width=100%>
						<tr>
							<td class="td_normal_title" width="15%">审批意见可阅读者</td>
							<td width="85%" colspan='3'>
								<xform:address textarea="true" mulSelect="true" propertyId="authAppRecReaderIds" propertyName="authAppRecReaderNames" style="width:97%;height:90px;" ></xform:address>
							    <br><span class="com_help"><bean:message bundle="sys-right" key="right.read.authReaders.note1" /></span>
							</td>
						</tr>
						<c:import url="/sys/right/right_edit.jsp" charEncoding="UTF-8">
							<c:param name="formName" value="kmImissiveSendMainForm" />
							<c:param name="moduleModelName" value="com.landray.kmss.km.imissive.model.KmImissiveSendMain" />
						</c:import>
					</table>
				</ui:content>
				<!-- 权限机制 -->
			</ui:tabpage>
			<html:hidden property="method_GET"/>
		</html:form>
		<%@ include file="/km/imissive/cookieUtil_script.jsp"%>
<script language="JavaScript">
	$KMSSValidation(document.forms['kmImissiveSendMainForm']);
</script>
<script language="JavaScript">
$(document).ready(function(){
	<c:if  test="${kmImissiveSendMainForm.sysWfBusinessForm.fdNodeAdditionalInfo.modifyDocNum =='true' and sysNumberFlag != 'unlimited' and kmImissiveSendMainForm.method_GET=='add'}">
	 generateAutoNum();
	</c:if>
});
seajs.use(['sys/ui/js/dialog'], function(dialog) {
	window.dialog = dialog;
});
var tempDocNum = "";
//文档加载时自动获取文号
function generateAutoNum(){
	 var docNum = document.getElementsByName("fdDocNum")[0];
	if("${fdNoId}" != ""){
	if(getValueFromCookie("${fdNoId}")){
		docNum.value = getValueFromCookie("${fdNoId}");
	    tempDocNum=getValueFromCookie("${fdNoId}");
	    document.getElementById("docnum").innerHTML = getValueFromCookie("${fdNoId}");
	    if(Attachment_ObjectInfo['editonline']){
	           Attachment_ObjectInfo['editonline'].setBookmark('docnum',getValueFromCookie("${fdNoId}"));
	    }
	}else{
	    var url="${KMSS_Parameter_ContextPath}km/imissive/km_imissive_send_main/kmImissiveSendMain.do?method=generateNumByNumberId"; 
		 $.ajax({     
  	     type:"post",   
  	     url:url,     
  	     data:{fdNumberId:"${fdNoId}",fdId:"${kmImissiveSendMainForm.fdId}"},
  	     async:false,    //用同步方式 
  	     success:function(data){
  	 	    var results =  eval("("+data+")");
  		    if(results['docNum']!=null){
  		   	   docNum.value = results['docNum'];
  		       tempDocNum=results['docNum'];
  		       document.getElementById("docnum").innerHTML = results['docNum'];
  		       //填充控件中的文号书签 
  		        if(Attachment_ObjectInfo['editonline']){
  		           Attachment_ObjectInfo['editonline'].setBookmark('docnum',document.getElementsByName("fdDocNum")[0].value);
  		      }
  			}
  		   document.cookie=("${fdNoId}="+results['docNum']);
  		}    
      });
	}
  }
}

//文件编号
   function generateFileNum(){
	        var docNum = document.getElementsByName("fdDocNum")[0];
		    path=Com_GetCurDnsHost()+Com_Parameter.ContextPath+'km/imissive/km_imissive_send_main/kmImissiveNum.jsp?fdId=${kmImissiveSendMainForm.fdId}&fdNoId=${fdNoId}&tempDocNum='+encodeURI(tempDocNum);
		    dialog.iframe(path,"文件编号",function(rtn){
			  if(rtn!="undefined"&&rtn!=null){
	    		  docNum.value = rtn;
	   		      tempDocNum=rtn;
	   		      document.getElementById("docnum").innerHTML = rtn;
	   		      //填充控件中的文号书签
	   		      if(Attachment_ObjectInfo['editonline']){
	   		         Attachment_ObjectInfo['editonline'].setBookmark('docnum',document.getElementsByName("fdDocNum")[0].value);
	   		      }
			  }
		   },{width:400,height:200});
	}
	
 var redheadFlag = ""; //是否进行套红标示
 <c:if  test="${kmImissiveSendMainForm.sysWfBusinessForm.fdNodeAdditionalInfo.modifyDocNum =='true'}">
   Com_Parameter.event["submit"].push(function(){
	   var flag = true;
	   var docNum = document.getElementsByName("fdDocNum")[0];
	   if(""==docNum.value){
		   flag =  confirm("当前节点有文件编号附加选项,发文文号还为空,是否继续提交？");
	   }
	   return flag;
   });
 </c:if>
 
<c:if  test="${kmImissiveSendMainForm.sysWfBusinessForm.fdNodeAdditionalInfo.redhead =='true'}">
 Com_Parameter.event["submit"].push(function(){
	   var flag = true;
	   if(""==redheadFlag){
		   flag =  confirm("当前节点有套红附加选项,还未套红,是否继续提交？");
	   }
	   return flag;
 });
</c:if>
</script>
</template:replace>
<template:replace name="nav">
	<!-- 关联机制 -->
		<c:import url="/sys/relation/import/sysRelationMain_edit.jsp" charEncoding="UTF-8">
		   <c:param name="formName" value="kmImissiveSendMainForm" />
	    </c:import>
	<!-- 关联机制 -->
</template:replace>
</template:include>
