component table="TTestResult" persistent="true"
{
	property name="id" column="id" fieldtype="id" generator="identity";
	//property name="TesterID";
	property name="Version";
	property name="ElapsedTime";
	property name="Comment";
	property name="DateTested" ormtype="timestamp" notnull="true";
	property name="AttachmentList";
	property name="TestCaseID" ormtype="integer";
	property name="Defects";
	property name="StatusID" ormtype="integer";
	property name="TesterID" ormtype="integer";
	//property name="TTestStatus" fieldtype="one-to-one" cfc="TTestStatus" fkcolumn="StatusID";
	//property name="TTestTester" fieldtype="one-to-one" cfc="TTestTester" fkcolumn="TesterID";
	
	public TTestResult function init() 
	{
		if (IsNull(variables.ElapsedTime)) 
		{
			variables.ElapsedTime = 0;
		}
		if (IsNull(variables.Version))
		{
			variables.Version = 0;
		}
		return this;
	}
	public any function getElapsedTime() {
		if (IsNull(variables.ElapsedTime)) {
			return 0;
		} else {
			return variables.ElapsedTime;
		}
	}
	public any function getVersion() {
		if (IsNull(variables.Version)) {
			return 0;
		} else {
			return variables.Version;
		}
	}
	
	public void function postInsert() {
		//update any old case history for caseid
		if (variables.StatusID != 1) {
		updatequery = new Query();
		updatequery.setSql("UPDATE TTestCaseHistory SET DateActionClosed = :dateclosed WHERE caseid = :caseid AND DateActionClosed is NULL");
		updatequery.addParam(name="dateclosed",value=Now(),cfsqltype="cf_sql_timestamp");
		updatequery.addParam(name="caseid",value=this.getTestCaseID(),cfsqltype="cf_sql_integer");
		updatequery.execute().getResult();
		newcasehistory = EntityNew("TTestCaseHistory");
		teststatus = EntityLoadByPK("TTestStatus",variables.StatusID);
		newcasehistory.setAction(teststatus.getStatus());
		newcasehistory.setTesterID(variables.TesterID);
		newcasehistory.setDateOfAction(Now());
		//if ( this.getTTestStatus().getStatus() == "Passed" ) {
		//	newcasehistory.setDateActionClosed(now());
		//}
		newcasehistory.setCaseId(this.getTestCaseID());
		EntitySave(newcasehistory);
		}
		//if axosoft
	}
}