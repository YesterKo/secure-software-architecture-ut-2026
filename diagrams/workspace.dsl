workspace "Citizen Services Portal" "C4 architecture model for the Citizen Services Portal" {

    !identifiers hierarchical

    model {
        citizen = person "Citizen / Resident" "Uses digital citizen services through a unified portal."

        administrator = person "Administrator / Helpdesk Staff" "Provides permitted support and performs authorized administrative tasks."

        auditor = person "Auditor / Oversight" "Reviews permitted audit and transparency information."

        portal = softwareSystem "Citizen Services Portal" "Provides a unified digital entry point for interacting with digital services and registries." {
            web = container "Web Application" "Provides the user-facing interface for citizens, support staff, and auditors." {
                tags "Web"
            }

            backend = container "Backend Application" "Provides portal business logic, authorization, workflow coordination, validation, document operations, notification initiation, and the API used by the Web Application."

            integration = container "Integration Service" "Isolates external-system integrations and handles system-specific communication, data mapping, and integration failures." 

            db = container "Portal Database" "Stores portal-owned application data such as preferences, workflow coordination state, notification metadata, and configuration." {
                tags "Database"
            }

            documents = container "Document Store" "Stores documents retained or temporarily processed by the portal." {
                tags "Store"
            }

            audit = container "Audit Store" "Stores security-relevant portal audit events with restricted access and integrity requirements." {
                tags "Store"
            }
            
        }




        tara = softwareSystem "State Authentication Service (TARA)" "External identity provider operated by RIA and used for strong authentication with supported Estonian eID methods."

        kvkr = softwareSystem "Kaitseväekohustuslaste register (KVKR)" "Authoritative defence-obligation register operated by Kaitseressursside Amet (KRA)."

        defenceForces = softwareSystem "Estonian Defence Forces Systems" "Authoritative Defence Forces systems providing data and functionality to portal services."

        tis = softwareSystem "Health Information System (TIS)" "Authoritative health information system accessed through TEHIK-managed interfaces."

        notificationProviders = softwareSystem "Email/SMS Notification Providers" "Trusted external services used to deliver portal notifications."

        citizen -> portal.web "Uses to access citizen services"
        administrator -> portal.web "Uses for permitted support and administration"
        auditor -> portal.web "Uses to review permitted audit and transparency information"

        portal.web -> portal.backend "Requests portal data and operations from"

        portal.backend -> tara "Uses for user authentication" "OIDC"

        portal.backend -> portal.db "Reads from and writes portal-owned app data"
        portal.backend -> portal.documents "Stores and retrieves documents"
        portal.backend -> portal.audit "Writes audit events and reads permitted audit information"
        portal.backend -> notificationProviders "Sends notification requests"

        portal.backend -> portal.integration "Requests external data and operations via"

        portal.integration -> kvkr "Exchanges required defence-obligation data"
        portal.integration -> defenceForces "Exchanges required defence-service workflow data"
        portal.integration -> tis "Requests required health information" "X-tee"
    }

    views {
        systemContext portal "C4Context" {
            include *
        }

        container portal "C4Container" {
            include *
        }

        styles {
            element "Element" {
                color #9a28f8
                stroke #9a28f8
                strokeWidth 7
                shape roundedbox
            }
            element "Person" {
                shape person
            }
            element "Database" {
                shape cylinder
            }
            element "Boundary" {
                strokeWidth 5
            }
            element "Web" {
                shape webbrowser
            }  
            element "Store" {
                shape cylinder
            }   
            relationship "Relationship" {
                thickness 4
            }
        }
    }

    configuration {
        scope softwaresystem
    }

}