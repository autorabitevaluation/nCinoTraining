<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>LLC_BI__Close_Date_Moved</fullName>
        <ccEmails>inactive@ncino.com</ccEmails>
        <description>Close Date Moved</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>PSO_Email_Templates/ET55_Unused_Alert_Template</template>
    </alerts>
    <alerts>
        <fullName>LLC_BI__Guarantee_Fee_Not_Paid</fullName>
        <ccEmails>inactive@ncino.com</ccEmails>
        <description>Guarantee Fee Not Paid</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>PSO_Email_Templates/ET55_Unused_Alert_Template</template>
    </alerts>
    <alerts>
        <fullName>LLC_BI__Loan_Withdrawn_Declined</fullName>
        <ccEmails>inactive@ncino.com</ccEmails>
        <description>Loan Withdrawn / Declined</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>PSO_Email_Templates/ET55_Unused_Alert_Template</template>
    </alerts>
    <alerts>
        <fullName>LLC_BI__Order_New_Appraisal_Alert</fullName>
        <ccEmails>inactive@ncino.com</ccEmails>
        <description>Order New Appraisal Alert</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>PSO_Email_Templates/ET55_Unused_Alert_Template</template>
    </alerts>
    <alerts>
        <fullName>LLC_BI__Stage_Change_to_Compliance</fullName>
        <ccEmails>inactive@ncino.com</ccEmails>
        <description>Stage Change to Compliance</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>PSO_Email_Templates/ET55_Unused_Alert_Template</template>
    </alerts>
    <fieldUpdates>
        <fullName>Default_Opportunity_Name</fullName>
        <description>Enforces an Opportunity naming convention. Added for the Commercial Accelerate project.</description>
        <field>Name</field>
        <formula>IF(LEN(Account.Name) &gt; 120,
LEFT(Account.Name, 89),
Account.Name
) &amp; &apos; - &apos; &amp; &apos;$&apos; &amp;
IF(ISBLANK(Amount),
&apos;0&apos;,
IF(
Amount &gt;= 1000000,
TEXT(FLOOR(Amount / 1000000)) &amp; &apos;,&apos;,
&apos;&apos;) &amp;
IF(
Amount &gt;= 1000,
RIGHT(TEXT(FLOOR(Amount / 1000)), 3) &amp; &apos;,&apos;,
&apos;&apos;) &amp;
RIGHT(TEXT(FLOOR(Amount)), 3) &amp; &apos;.&apos; &amp;
IF(
MOD(Amount, 1) * 100 &lt; 10,
&apos;0&apos; &amp; TEXT(ROUND(MOD(Amount, 1), 2) * 100),
TEXT(MIN(ROUND(MOD(Amount, 1), 2) * 100, 99))
)) &amp; &apos; - &apos; &amp; TEXT(MONTH(DATEVALUE(CreatedDate))) &amp; &apos;/&apos; &amp; TEXT(DAY(DATEVALUE(CreatedDate))) &amp; &apos;/&apos; &amp; TEXT(YEAR(DATEVALUE(CreatedDate)))</formula>
        <name>Default Opportunity Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__Update_Start_Date_of_Current_Stage</fullName>
        <field>LLC_BI__Start_Date_at_Current_Stage__c</field>
        <formula>TODAY()</formula>
        <name>Update Start Date of Current Stage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Stage_Update_Qualification</fullName>
        <field>StageName</field>
        <literalValue>Qualification</literalValue>
        <name>Stage Update - Qualification</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage_to_Prospecting</fullName>
        <description>Updates Opportunity stage to Prospecting. Added for the Commercial Accelerate project.</description>
        <field>StageName</field>
        <literalValue>Prospecting</literalValue>
        <name>Update Stage to Prospecting</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>CAB_Default Opportunity Name</fullName>
        <actions>
            <name>Default_Opportunity_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Enforces an Opportunity naming convention. Added for the Commercial Accelerate project.</description>
        <formula>AND(     OR(         ISNEW(),         ISCHANGED(Amount)     ), $User.No_Workflow__c = False )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CAB_Update Stage to Prospecting</fullName>
        <actions>
            <name>Update_Stage_to_Prospecting</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates Opportunity Stage to Prospecting prior to Opportunity conversion. Added for the Commercial Accelerate project.</description>
        <formula>$User.No_Workflow__c = False</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CAB_Update Stage to Qualification</fullName>
        <actions>
            <name>Stage_Update_Qualification</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates Opportunity Stage to Qualification after Opportunity conversion. Added for the Commercial Accelerate project.</description>
        <formula>AND( $User.No_Workflow__c = False, ISCHANGED(cm_Conversion_Complete__c), cm_Conversion_Complete__c = true )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LLC_BI__Update Start Date of Current Stage</fullName>
        <actions>
            <name>LLC_BI__Update_Start_Date_of_Current_Stage</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(StageName)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>