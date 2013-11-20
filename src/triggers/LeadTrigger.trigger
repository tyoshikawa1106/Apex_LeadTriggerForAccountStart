/**
 * Lead Trigger
 * © 2013 Force.com Developer
 * ----------------------------------------
 * @createdDate      : 2013/01/01
 * @createdName      : Taiki,Yoshikawa
 * ----------------------------------------
 * @lastModifiedDate : 2013/01/01
 * @lastModifiedName : Taiki,Yoshikawa
 * ----------------------------------------
 */
trigger LeadTrigger on Lead (after update) {
    System.debug('LeadTrigger:START');
    
    // Handlerクラス
    LeadTriggerHandler handler = new LeadTriggerHandler();
    
    if (Trigger.isAfter) {
        if (Trigger.isUpdate) {
            // リードの取引開始時にアンケートを更新
            handler.doUpdateQuestionnaire(Trigger.new, Trigger.old);
            // リードの取引開始時に取引先責任者を更新
            handler.doUpdateContact(Trigger.new, Trigger.old);
        }
    }
    
    System.debug('LeadTrigger:END');
}