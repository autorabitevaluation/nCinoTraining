<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Loan_Default_App</fullName>
        <field>LLC_BI__Default_App__c</field>
        <formula>IF(
ISPICKVAL(LLC_BI__Product_Line__c, &quot;Commercial Loan&quot;),
&apos;ub-loan.ub-loan-loan-dashboard&apos;,
IF(
ISPICKVAL(LLC_BI__Product_Line__c, &quot;Consumer Loan&quot;),
&apos;m-retail.m-retail-loan-details&apos;,
&apos;m-commercial.dashboard-loan&apos;))</formula>
        <name>Loan - Default App</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Commercial Product Line-Record Type</fullName>
        <actions>
            <name>Assign_Commercial_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>LLC_BI__Loan__c.LLC_BI__Product_Line__c</field>
            <operation>equals</operation>
            <value>Commercial</value>
        </criteriaItems>
        <description>Upon creation, Loans with a Product Line of Commercial will be assigned the Commercial record type</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>