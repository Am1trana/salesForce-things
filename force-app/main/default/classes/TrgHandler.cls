public class TrgHandler {
    public static void checkRelatedDeadContact(List<Contact> conList, Map<Id, Contact> conMap) 
    {
		Set<Id> conId = new Set<Id>();
		Set<Id> accId = new Set<Id>();
        if (!conList.isEmpty()) {
            for (Contact con : conList) {
                if(conMap != null){
                    if (con.Dead__c == true && con.Dead__c != conMap.get(con.Id).Dead__c && con.AccountId != null) {
                    conId.add(con.Id);
                    accId.add(con.AccountId);
                }
                }else{
                    if (con.AccountId != null){
                        conId.add(con.Id);
                    	accId.add(con.AccountId);
                    }
                }
                
            }
 
        }
        Map<Id, Integer> accountContactCountMap = new Map<Id, Integer>();
        List<AggregateResult> accountsWithContactCount = [SELECT AccountId, COUNT(Id) ContactCount FROM Contact WHERE accountId IN: accId GROUP BY AccountId];
        for(AggregateResult ar: accountsWithContactCount){
            accountContactCountMap.put((Id)ar.get('AccountId') , (Integer)ar.get('ContactCount'));
        }
        Map<Id, Integer> accountDeadContactCountMap = new Map<Id, Integer>();
        List<AggregateResult> accountsWithDeadContactCount = [SELECT AccountId, COUNT(Id) dCon FROM Contact WHERE accountId IN: accId AND DEAD__c  = true GROUP BY AccountId];
        for(AggregateResult ar: accountsWithDeadContactCount){
            accountDeadContactCountMap.put((Id)ar.get('AccountId') , (Integer)ar.get('dCon'));
        }

        list<account> accList =[SELECT Id, Fall_Out__c FROM account WHERE id IN: accId];
        if(!accList.isEmpty()){
            for(account ac: accList){
                system.debug(accountContactCountMap);
                system.debug(accountDeadContactCountMap);
                system.debug(accountDeadContactCountMap.get(ac.id));
                system.debug(accountContactCountMap.get(ac.id));
                System.debug(ac.id);
                Integer deadConCount = accountDeadContactCountMap.get(ac.id) != null ? accountDeadContactCountMap.get(ac.id) : 0;
                Integer totalConCount = accountContactCountMap.get(ac.id);

                if(totalConCount != null && totalConCount > 0){
                    if((deadConCount/totalConCount)*100 > 70){
                        ac.Fall_Out__c = true;
                    }else{
                        ac.Fall_Out__c = false;
                    }
                }else{
                    ac.Fall_Out__c = false;
                }
                
                
            }
        }
        
        update accList;
    }  
}
















// system.debug(accId);
// list<contact> totalRelatedContact = [SELECT id FROM Contact WHERE accountId IN : accId ];
// list<contact> deadRelatedContact = [SELECT id FROM Contact WHERE accountId IN : accId AND DEAD__c  = true];
// system.debug(totalRelatedContact);
// system.debug(deadRelatedContact);
// Map<id, integer> conIdAndTotalCon = new Map<id, integer>();
// for(contact totalCon: totalRelatedContact){
//     conIdAndTotalCon.put(totalCon.Id,  totalRelatedContact.size());
// }
// Map<id, integer> conIdAndDeadCon = new Map<id, integer>();
// for(contact deadCon: deadRelatedContact){
//     conIdAndDeadCon.put(deadCon.Id,  deadRelatedContact.size());
// }

// system.debug(conIdAndDeadCon);
// system.debug(conIdAndTotalCon);
// system.debug(conIdAndDeadCon.get('003dM0000032HLBQA2'));


    
// list<account> accToUpdate = new list<account>();
// if (!conList.isEmpty()) {
//     for (Contact con : conList){
//         system.debug(con.id);
//         system.debug(conIdAndDeadCon.get(con.id));
//         //system.debug(conIdAndTotalCon.get(con.id));
//         if(conIdAndDeadCon.containsKey(con.id)){
//             if((conIdAndDeadCon.get(con.id)/conIdAndTotalCon.get(con.id))*100 > 70){
//             account acc = new account();
//             acc.Fall_Out__c = true;
//             acc.id =con.accountId;
//               accToUpdate.add(acc);  
//         }
//        }
        
//     } 

// }
// if(!accToUpdate.isEmpty()){
//     update accToUpdate;
// } 
// }