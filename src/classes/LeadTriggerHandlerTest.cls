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
@isTest
private class LeadTriggerHandlerTest {

    /**
     * リードの取引開始時にアンケートを更新・テスト
     * リードに紐付くアンケート：0件
     */
    static testMethod void doUpdateQuestionnaireTest1() {
            
        // リードのテストデータ作成
        Lead objLead = createLead();
        insert objLead;
            
        Test.startTest();
            
        // convertLead 
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(objLead.id);
            
        LeadStatus convertStatus = getLeadStatus();
        lc.setConvertedStatus(convertStatus.MasterLabel);
            
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
            
        // リードに紐付くアンケート取得
        List<Questionnaire__c> objQuestionnaires = getQuestionnaires(objLead);
        System.assertEquals(objQuestionnaires.isEmpty(), true);
            
        Test.stopTest();
    }
    
    /**
     * リードの取引開始時にアンケートを更新・テスト
     * リードに紐付くアンケート：1件
     */
    static testMethod void doUpdateQuestionnaireTest2() {
            
        // リードのテストデータ作成
        Lead objLead = createLead();
        insert objLead;
            
        // アンケート取得
        Questionnaire__c objQuestionnaire = createQuestionnaire(objLead);
        insert objQuestionnaire;
            
        Test.startTest();
            
        // convertLead 
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(objLead.id);
            
        LeadStatus convertStatus = getLeadStatus();
        lc.setConvertedStatus(convertStatus.MasterLabel);
            
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
            
        // リードに紐付くアンケート取得
        List<Questionnaire__c> resusts = getQuestionnaires(objLead);
        System.assertEquals(resusts.size(), 1);
        for (Questionnaire__c q : resusts) {
            System.assertNotEquals(q.ContactId__c, null);
        }
            
        Test.stopTest();
    }
    
    /**
     * リードの取引開始時にアンケートを更新・テスト
     * リードに紐付くアンケート：複数件
     */
    static testMethod void doUpdateQuestionnaireTest3() {
        
        // リスト件数
        Integer listCnt = 200;
            
        // リードのテストデータ作成
        Lead objLead = createLead();
        insert objLead;
            
        // アンケート取得
        List<Questionnaire__c> objQuestionnaires = new List<Questionnaire__c>();
        for (Integer i = 0; i < listCnt; i++) {
            objQuestionnaires.add(createQuestionnaire(objLead));
        }
        // アンケートのテストデータ作成
        insert objQuestionnaires;
            
        Test.startTest();
            
        // convertLead 
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(objLead.id);
            
        LeadStatus convertStatus = getLeadStatus();
        lc.setConvertedStatus(convertStatus.MasterLabel);
            
        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
            
        // リードに紐付くアンケート取得
        List<Questionnaire__c> resusts = getQuestionnaires(objLead);
        System.assertEquals(resusts.size(), listCnt);
        for (Questionnaire__c q : resusts) {
            // アンケートの取引先責任者がNULLでないことを確認
            System.assertNotEquals(q.ContactId__c, null);
        }
            
        Test.stopTest();
    }
    
    /**
     * リードテストデータ作成
     * @param   : なし
     * @return  : リード
     */
    private static Lead createLead() {
        // リード
        Lead objLead = new Lead();
        // 姓
        objLead.LastName = 'LastName';
        // 名
        objLead.FirstName = 'FirstName';
        // 会社
        objLead.Company = 'TEST';
        
        return objLead;
    }
    
    /**
     * リードステータス取得
     * @param   : なし
     * @return  : リードステータス
     */
    private static LeadStatus getLeadStatus() {
        return [
            select
                 Id
                ,MasterLabel
            from
                LeadStatus
            where
                IsConverted = true
            limit 1
        ];
    }
    
    /**
     * アンケートテストデータ作成
     * @param   : リード       [prmLead]
     * @return  : アンケート
     */
    private static Questionnaire__c createQuestionnaire(Lead prmLead) {
        // アンケート
        Questionnaire__c objQuestionnaire = new Questionnaire__c();
        // リード
        objQuestionnaire.LeadId__c = prmLead.Id;
        // 取引先責任者
        objQuestionnaire.ContactId__c = null;
        
        return objQuestionnaire;
    } 
    
    /**
     * リードに紐付くアンケート取得
     * @param   : リード       [prmLead]
     * @return  : アンケート
     */
    private static List<Questionnaire__c> getQuestionnaires(Lead prmLead) {
        return [
            select
                Id
                ,ContactId__c
            from
                Questionnaire__c
            where
                LeadId__c =: prmLead.Id
        ];
    }   
}