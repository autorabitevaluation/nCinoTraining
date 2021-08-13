<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UB_Financial_Assets</fullName>
        <field>RecordTypeId</field>
        <lookupValue>UB_Financial_Assets</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>UB_Financial_Assets</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UB_Insurance</fullName>
        <field>RecordTypeId</field>
        <lookupValue>UB_Insurance</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>UB_Insurance</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UB_Marketable_Securities</fullName>
        <field>RecordTypeId</field>
        <lookupValue>UB_Marketable_Securities</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>UB_Marketable Securities</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UB_Miscellaneous_Assignment</fullName>
        <field>RecordTypeId</field>
        <lookupValue>UB_Miscellaneous_Assignment</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>UB_Miscellaneous Assignment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UB_Real_Estate</fullName>
        <field>RecordTypeId</field>
        <lookupValue>UB_Real_Estate</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>UB_Real Estate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UB_Titled</fullName>
        <field>RecordTypeId</field>
        <lookupValue>UB_Titled</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>UB_Titled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UB_UCC</fullName>
        <description>Specifies the UB_UCC</description>
        <field>RecordTypeId</field>
        <lookupValue>UB_UCC</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>UB_UCC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>UB_Financial Assets</fullName>
        <actions>
            <name>UB_Financial_Assets</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Specifies page layout for Collateral2 based on Collateral Type</description>
        <formula>AND(OR(ISNEW(), ISCHANGED(LLC_BI__Collateral_Type__c)), TEXT(LLC_BI__Collateral_Type__r.LLC_BI__Type__c) = &quot;Financial Assets&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UB_Insurance</fullName>
        <actions>
            <name>UB_Insurance</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Specifies page layout for Collateral2 based on Collateral Type</description>
        <formula>AND(OR(ISNEW(), ISCHANGED(LLC_BI__Collateral_Type__c)), TEXT(LLC_BI__Collateral_Type__r.LLC_BI__Type__c) = &quot;Insurance&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UB_Marketable Securities</fullName>
        <actions>
            <name>UB_Marketable_Securities</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Specifies page layout for Collateral2 based on Collateral Type</description>
        <formula>TEXT(LLC_BI__Collateral_Type__r.LLC_BI__Type__c) = &quot;Marketable Securities&quot;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>UB_Miscellaneous Assignment</fullName>
        <actions>
            <name>UB_Miscellaneous_Assignment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Specifies page layout for Collateral2 based on Collateral Type</description>
        <formula>AND(OR(ISNEW(), ISCHANGED(LLC_BI__Collateral_Type__c)), TEXT(LLC_BI__Collateral_Type__r.LLC_BI__Type__c) = &quot;Miscellaneous Assignment&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UB_Real Estate</fullName>
        <actions>
            <name>UB_Real_Estate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Specifies page layout for Collateral2 based on Collateral Type</description>
        <formula>AND(OR(ISNEW(), ISCHANGED(LLC_BI__Collateral_Type__c)), TEXT(LLC_BI__Collateral_Type__r.LLC_BI__Type__c) = &quot;Real Estate&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UB_Titled</fullName>
        <actions>
            <name>UB_Titled</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Specifies page layout for Collateral2 based on Collateral Type</description>
        <formula>AND(OR(ISNEW(), ISCHANGED(LLC_BI__Collateral_Type__c)), TEXT(LLC_BI__Collateral_Type__r.LLC_BI__Type__c) = &quot;Titled&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>UB_UCC</fullName>
        <actions>
            <name>UB_UCC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Specifies page layout for Collateral2 based on Collateral Type</description>
        <formula>AND(OR(ISNEW(), 							ISCHANGED(LLC_BI__Collateral_Type__c)), TEXT(LLC_BI__Collateral_Type__r.LLC_BI__Type__c) = &quot;UCC&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>