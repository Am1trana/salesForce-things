trigger chkRealtedDeadCon on Contact (after insert, after delete, after update, after undelete) {
    
    if(trigger.isAfter && (trigger.isUpdate)){
        TrgHandler.checkRelatedDeadContact(trigger.new, trigger.oldMap);
        
    }else if(trigger.isAfter && (trigger.isDelete)){
        TrgHandler.checkRelatedDeadContact(trigger.old, null);
        
    } else if((trigger.isAfter && (trigger.isInsert || trigger.isUndelete))) {
        TrgHandler.checkRelatedDeadContact(trigger.new, null);
    }
}