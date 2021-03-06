package com.landray.kmss.tib.jdbc.service.bean;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.landray.kmss.common.actions.RequestContext;
import com.landray.kmss.common.dao.HQLInfo;
import com.landray.kmss.common.service.IXMLDataBean;
import com.landray.kmss.tib.jdbc.service.ITibJdbcTaskCategoryService;
import com.landray.kmss.util.StringUtil;

public class TibJdbcTaskCategoryTreeServiceImp implements IXMLDataBean {

	private ITibJdbcTaskCategoryService tibJdbcTaskCategoryService;

	public void setTibJdbcTaskCategoryService(
			ITibJdbcTaskCategoryService tibJdbcTaskCategoryService) {
		this.tibJdbcTaskCategoryService = tibJdbcTaskCategoryService;
	}

	public ITibJdbcTaskCategoryService getTibJdbcTaskCategoryService() {
		return tibJdbcTaskCategoryService;
	}



	
	public List getDataList(RequestContext requestInfo) throws Exception {
		
		String parentId = requestInfo.getParameter("parentId");
		HQLInfo hqlInfo = new HQLInfo();
		hqlInfo.setSelectBlock("tibJdbcTaskCategory.fdName, tibJdbcTaskCategory.fdId");
		if (StringUtil.isNull(parentId)) {
			hqlInfo.setWhereBlock("tibJdbcTaskCategory.hbmParent is null");
		} else {
			hqlInfo
					.setWhereBlock("tibJdbcTaskCategory.hbmParent.fdId=:parentId");
			hqlInfo.setParameter("parentId", parentId);
		}
		List<?> result = tibJdbcTaskCategoryService.findList(hqlInfo);
		List<Map<String, String>> rtnList = new ArrayList<Map<String, String>>();
		for (int i = 0; i < result.size(); i++) {
			Object[] obj = (Object[]) result.get(i);
			Map<String, String> node = new HashMap<String, String>();
			node.put("text", obj[0].toString());
			node.put("value", obj[1].toString());
			rtnList.add(node);
		}
		return rtnList;
	
	}

}
