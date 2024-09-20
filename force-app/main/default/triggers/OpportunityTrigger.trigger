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
}