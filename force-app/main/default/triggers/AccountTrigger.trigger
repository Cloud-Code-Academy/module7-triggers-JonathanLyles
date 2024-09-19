trigger AccountTrigger on Account (before insert){
    for(Account a : Trigger.new){
        //Lists of Billing and Shipping Fields
        List<String> fieldList = new List<String>{'Street','City', 'State','PostalCode', 'Country'};
         
       
        //If Type is null or empty assign 'Prospect'
        if(a.Type == null){
            a.Type = 'Prospect';
        }

        //For each account, copy the shipping fields to the billing fields, unless the field is null or empty
        for(String field : fieldList){
            if(a.get('Shipping' + field) != null){
                // Use the set method correctly
                a.put('Billing' + field, a.get('Shipping' + field));
            }
        }

        //Set rating to 'Hot' if phone, website, and fax all have a value. 
        if(a.get('Rating') != 'Hot'){
            if(a.get('Phone') != null && a.get('Website') != null && a.get('Fax') != null){
                a.put('Rating','Hot');
            }
        }
    }
}