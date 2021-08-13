<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Account_Update_NAICS_Code</fullName>
        <field>LLC_BI__Naics_Code__c</field>
        <formula>cm_Industry_Code__r.cm_Industry_Code__c</formula>
        <name>Account - Update NAICS Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__Set_Account_Business_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>LLC_BI__Business</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Account Business Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__Set_Account_Household_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>LLC_BI__Household</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Account Household Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__Set_Account_Individual_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>LLC_BI__Individual</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Account Individual Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__Set_Default_App_to_Counterparty_Report</fullName>
        <description>Update default app to Counterparty Report</description>
        <field>LLC_BI__Default_App__c</field>
        <literalValue>counterparty-report.counterparty-report</literalValue>
        <name>Set Default App to Counterparty Report</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__Update_Record_Type_to_Lender</fullName>
        <description>If Account type is &quot;Institutional Investor&quot; or &quot;Financial Institution&quot; update record type to Lender.</description>
        <field>RecordTypeId</field>
        <lookupValue>LLC_BI__Lender</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type to Lender</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Default_App_Master_Relationship</fullName>
        <field>LLC_BI__Default_App__c</field>
        <formula>&apos;master-relationship.master-relationship-loan-products&apos;</formula>
        <name>Set Default App-Master Relationship</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Account - Industry Code Lookup Populated</fullName>
        <actions>
            <name>Account_Update_NAICS_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When the Industry Code field is populated on the Account, populate the NAICS Code Text field.</description>
        <formula>AND( $User.No_Workflow__c = false, OR( ISNEW(), ISCHANGED(cm_Industry_Code__c) ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LLC_BI__Account Set Business Record Type</fullName>
        <actions>
            <name>LLC_BI__Set_Account_Business_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>notEqual</operation>
            <value>Household,Individual,Sole Proprietorship,Financial Institution,Institutional Investor</value>
        </criteriaItems>
        <description>sets Record Type to Business if Account Type is not &quot;Household&quot;, &quot;Sole Proprietorship&quot;, &quot;Institutional Investor&quot;, &quot;Financial Institution&quot; or &quot;Individual&quot;</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LLC_BI__Account Set Household Record Type</fullName>
        <actions>
            <name>LLC_BI__Set_Account_Household_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>equals</operation>
            <value>Household</value>
        </criteriaItems>
        <description>sets Record Type to Household if Account Type is &quot;Household&quot;</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LLC_BI__Account Set Individual Record Type</fullName>
        <actions>
            <name>LLC_BI__Set_Account_Individual_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>equals</operation>
            <value>Individual,Sole Proprietorship</value>
        </criteriaItems>
        <description>sets Record Type to Individual if Account Type is &quot;Sole Proprietorship&quot; or &quot;Individual&quot;</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LLC_BI__Account Set Lender Record Type</fullName>
        <actions>
            <name>LLC_BI__Update_Record_Type_to_Lender</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Type</field>
            <operation>equals</operation>
            <value>Financial Institution,Institutional Investor</value>
        </criteriaItems>
        <description>sets Record Type to Lender if Account Type is &quot;Financial Institution&quot; or &quot;Institutional Investor&quot;</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LLC_BI__Set Default App for Lenders</fullName>
        <actions>
            <name>LLC_BI__Set_Default_App_to_Counterparty_Report</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Lender</value>
        </criteriaItems>
        <description>When Record Type is Lender, set default app to be counterparty report.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Default App-Master Relationship</fullName>
        <actions>
            <name>Set_Default_App_Master_Relationship</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>1=1</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>