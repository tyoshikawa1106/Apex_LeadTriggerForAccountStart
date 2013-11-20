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
public with sharing class LeadTriggerHandler {
    
    /**
     * コンストラクタ
     */
    public LeadTriggerHandler() {
        
    }
    
    /**
     * リードの取引開始時にアンケートを更新
     * @param   : 更新後のリード   [prmLeadNews]
     * @param   : 更新前のリード   [prmLeadOlds]
     * @return  : なし
     */
    public void doUpdateQuestionnaire(List<Lead> prmLeadNews, List<Lead> prmLeadOlds) {
        System.debug('doUpdateQuestionnaire:START');
        
        Set<Id> leadIds = new Set<Id>();
        for (Integer i = 0; i < prmLeadNews.size(); i++) {
            // リード取引開始判定
            if (prmLeadNews[i].IsConverted != prmLeadOlds[i].IsConverted && prmLeadNews[i].IsConverted == true) {
                leadIds.add(prmLeadNews[i].Id);
            }
        }
        
        // アンケート
        List<Questionnaire__c> objQuestionnaires = new List<Questionnaire__c>();
        
        // リード取得
        List<Lead> objLeads = getLeads(leadIds);
        for (Lead l : objLeads) {
            for (Questionnaire__c q : l.QuestionnaireLeadIds__r) {
                q.ContactId__c = l.ConvertedContactId;
                objQuestionnaires.add(q);
            }
        }
        
        // アンケートUPDATE
        update objQuestionnaires;
        
        System.debug('doUpdateQuestionnaire:END');
    }
    
    /**
     * リード取得
     * @param   : リードID     [prmLeadIds]
     * @return  : リード
     */
    private List<Lead> getLeads(Set<Id> prmLeadIds) {
        return [
            select
                Id
                ,ConvertedContactId
                ,(select Id,ContactId__c from QuestionnaireLeadIds__r)
            from
                Lead
            where
                Id IN: prmLeadIds
            and
                IsConverted = true
        ];
    }
    
    /**
     * リードの取引開始時に取引先責任者を更新
     * @param   : 更新後のリード   [prmLeadNews]
     * @param   : 更新前のリード   [prmLeadOlds]
     * @return  : なし
     */
    public void doUpdateContact(List<Lead> prmLeadNews, List<Lead> prmLeadOlds) {
        System.debug('doUpdateContact:START');
        
        Set<Id> contactIds = new Set<Id>();
        for (Integer i = 0; i < prmLeadNews.size(); i++) {
            // リード取引開始判定
            if (prmLeadNews[i].IsConverted != prmLeadOlds[i].IsConverted && prmLeadNews[i].IsConverted == true) {
                contactIds.add(prmLeadNews[i].ConvertedContactId);
            }
        }
        
        // 取引先責任者取得
        List<Contact> objContacts = getContacts(contactIds);
        for (Contact c : objContacts) {
            // リード登録
            c.LeadEntryFlg__c = true;
        }
        
        // 取引先責任者UPDATE
        update objContacts;
        
        System.debug('doUpdateContact:END');
    }
    
    /**
     * 取引先責任者取得
     * @param   : 取引先責任者ID      [prmContactIds]
     * @return  : 取引先責任者
     */
    private List<Contact> getContacts(Set<Id> prmContactIds) {
        return [
            select
                Id
            from
                Contact
            where
                Id IN: prmContactIds
        ];
    }
}