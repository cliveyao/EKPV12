

<%@ include file="/resource/jsp/edit_down.jsp"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="/WEB-INF/kmss-xform.tld" prefix="xform"%>
<%@ include file="/resource/jsp/edit_top.jsp"%>
<%@ include file="/sys/xform/include/sysForm_script.jsp"%>
<script type="text/javascript">
Com_IncludeFile("jquery.js|json2.js|dialog.js|formula.js|xml.js");
</script>

<script type="text/javascript" src="${KMSS_Parameter_ContextPath}tib/common/resource/plugins/XMLParseUtil.js"></script>
<script type="text/javascript" src="quartzCfg.js"></script>
<script>
XMLParseUtil.initDomByMozilla();

</script>
<div id="optBarDiv"><input type=button value="确定"
	onclick="submitFunc()"> <input type="button"
	value="<bean:message key="button.close"/>" onclick="Com_CloseWindow();">
</div>
<center>
<script type="text/javascript"
	src="${KMSS_Parameter_ContextPath}tib/common/resource/js/tools.js"></script>
<p class="txttitle">SAP 定时任务映射配置  <img src="${KMSS_Parameter_ContextPath}resource/style/default/tag/help.gif" title='帮助' style="cursor:hand" onclick='Com_OpenWindow("tibSapSyncSettingHelp.jsp","_blank")' ></img> </p>
<table id="rfcTabel" class="tb_normal" width=95% >

</table>
</center>




<%@ include file="/resource/jsp/edit_down.jsp"%>


