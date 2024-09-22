trigger OpportunityTrigger on Opportunity (before insert, before update, before delete) {

    //Question 5 - On update only, check if opportunity is great than 5000
    
    if(Trigger.isUpdate == true){
        for(Opportunity opp : Trigger.new){
            if(opp.Amount < 5000){
                opp.addError('Opportunity amount must be greater than 5000');
            }
        }

    }
    

    //Question 6 - On delete only, When an opportunity is deleted prevent the deletion of a closed won opportunity if the account industry is 'Banking'.
    //Get Account Ids
    Set<Id> accountIds   = new Set<Id>();

    if(Trigger.isDelete == true){
        for(Opportunity opp : Trigger.old){
            if(opp.AccountId != null){
                accountIds.add(opp.AccountId); 
            }
        }

        //Get related accounts
        Map<Id, Account> accountMap = new Map<Id, Account>([SELECT Id, Industry FROM Account WHERE Id IN :accountIds]);

        //Iterate each opportunity in Trigger.old and check the Industry Type
        for(Opportunity opp : Trigger.old){
            if(opp.StageName == 'Closed Won'){
                if(opp.AccountId != null && accountMap.containsKey(opp.AccountId)){
                    Account relatedAccount = accountMap.get(opp.AccountId);
                    if(relatedAccount.Industry == 'Banking'){
                        opp.addError('Cannot delete closed opportunity for a banking account that is won');
                    }                
                }
            }
        }
    }
    /**
    * Question 7 Opportunity Trigger
    * When an opportunity is updated set the primary contact on the opportunity to the contact on the same account with the title of 'CEO'.
    * Trigger should only fire on update.
    */ 
    if(Trigger.isUpdate){
        List<Id> accIDs = new List<Id>();
        for(Opportunity opp : Trigger.new){
            accIDs.add(opp.AccountId);
        }
        System.debug('Account Id: ' + accIDs);
        Map<Id,Id> accIdConIdMap = new Map<Id,Id>();
        for(Contact ceo : [SELECT Id, FirstName, Title, AccountId FROM Contact WHERE Title = 'CEO' AND AccountId IN :accIDs]){
            System.debug('Current CEO: ' + ceo);
            accIdConIdMap.put(ceo.AccountId,ceo.Id);
        }
        System.debug(accIdConIdMap);

        Map<Id,Map<Id,Id>> oppIdAccIdConIdMap = new Map<Id,Map<Id,Id>>();
        for(Opportunity opp : Trigger.new){
            opp.Primary_Contact__c = accIdConIdMap.get(opp.AccountId);
        }    
    }
}