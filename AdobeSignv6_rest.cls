// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-    
//  Outer wrapper classes used in project.
//  https://github.com/cmerrill-adobe/AdobeSignSalesforceApiV6
//  by Chris Merrill cmerrill.adobe@gmail.com
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-  
public class AdobeSignv6_rest {
    
    public class UserAgreements {
        public List<UserAgreement> userAgreementList;
    }
    
    public class UserAgreement {
        public string id;
        public string type;
        public string name;
        public string displayDate;
        public list<DisplayUserSetInfo> displayUserSetInfos;
        public string latestVersionId;
        public string status;
        public boolean esign;
        public boolean hidden;
    }
    
     public class DisplayUserSetInfo {
        public list<DisplayUserInfo> displayUserSetMemberInfos;
        public string displayUserSetName;
    }
    
    public class DisplayUserInfo {
        public string email;
        public string company;
        public string fullName;
    }
    
    public class Agreementinfo {
        public string agreementid;
        public List<DocumentHistoryEvent> events;
        public string latestVersionid;
        public string locale;
        public boolean modifiable;
        public string name;
        public List<NextPartipicantSetInfo> nextParticipantSetInfos;
        public List<ParticipantSetInfo> participantSetInfos;
        public string signatureType;
        public string status;
        public boolean vaultingEnabled;
        public string expiration;
        //        public ExternalId externalId;
        public string message;
        public List<String> securityOptions;
        
    }
    
    public class DocumentHistoryEvent {
        public string actingUserEmail;
        public string actingUserIpAddress;
        public string event_date;
        public string description;
        public string participantEmail;
        public string type;
        public string versoinId;
        public string comment;
        //        public string deviceLocation;
        public string synchronizationId;
        public string vaultEventId;
    }
    
    public class NextPartipicantSetInfo {
        public List<NextParticipantInfo> nextParticipantSetMemberInfos;
        public string nextParticipantSetName;
        public string status;
        public string participantSetId;
        public string participantId;
        public List<participantSetMemberInfos> participantSetMemberInfos;
    }
    
    public class NextParticipantInfo {
        public string email;
        public string waitingSince;
        public string name;
    }
    
    public class ParticipantSetInfo {
        public string participantSetId;
        public List<ParticipantInfo> participantSetMemberInfos;
        public List<String> roles;
        public string status;
        public string participantSetName;
        public string privateMessage;
        public List<String> securityOptions;
        public Integer signingOrder;
    }
    
    public class ParticipantInfo {
        public string email;
        public string participantid;
        public List<ParticipantSetInfo> alternateParticipants;
        public string company;
        public string name;
        public List<String> securityOptions;
        public string title;
    }
    
    public class participantSetMemberInfos {
        public string email;
        public string name;
        public string participantId;
    }
    
    public class signingURLS {
        public List<cls_signingUrlSetInfos> signingUrlSetInfos {get; set; }
    }
    
    public class cls_signingUrlSetInfos {
        public List<cls_signingUrls> signingUrls;
        public string signingUrlSetName;
    }
    
    public class cls_signingUrls {
        public String email;
        public String esignUrl;
    }

}