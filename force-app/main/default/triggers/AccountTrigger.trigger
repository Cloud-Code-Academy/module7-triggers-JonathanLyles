trigger AccountTrigger on Account (before insert){
    for(Account a : Trigger.new){
        if(a.Type == null){
            a.Type = 'Prospect';
        }
    }
}