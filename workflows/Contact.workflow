<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>LLC_BI__Set_Contact_Business_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>LLC_BI__Business_Contact</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Contact Business Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LLC_BI__Set_Contact_Individual_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>LLC_BI__Individual_Contact</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Contact Individual Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>LLC_BI__Contact Set Business Record Type</fullName>
        <actions>
            <name>LLC_BI__Set_Contact_Business_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.LLC_BI__Primary_Contact__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>sets Record Type to Business if Contact is not marked as primary</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LLC_BI__Contact Set Individual Record Type</fullName>
        <actions>
            <name>LLC_BI__Set_Contact_Individual_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.LLC_BI__Primary_Contact__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>sets Record Type to Individual if Contact is marked as primary</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>