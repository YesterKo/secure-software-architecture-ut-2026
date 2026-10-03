workspace "Citizen Services Portal" "C4 architecture model for the Citizen Services Portal" {

    !identifiers hierarchical

    model {
        citizen = person "Citizen / Resident" "Uses selected national-defence-related citizen services."

        administrator = person "Administrator / Helpdesk Staff" "Provides permitted support and performs authorized administrative tasks."

        auditor = person "Auditor / Oversight" "Reviews permitted audit and transparency information."

        portal = softwareSystem "Citizen Services Portal" "Provides a unified digital entry point for selected national-defence-related citizen services." {
            app = container "Portal Application" "Provides the web interface and portal-side application logic, including access control, service workflows, document handling, notifications, auditing, and external-system integration."

            db = container "Portal Database" "Stores portal-owned data such as preferences, workflow coordination state, notification metadata, and portal audit records. It is not authoritative for KVKR, TIS, or Defence Forces domain data." {
                tags "Database"
            }
        }

        tara = softwareSystem "State Authentication Service (TARA)" "External identity provider operated by RIA and used for strong authentication with supported Estonian eID methods."

        kvkr = softwareSystem "Kaitseväekohustuslaste register (KVKR)" "Authoritative defence-obligation register operated by Kaitseressursside Amet (KRA)."

        defenceForces = softwareSystem "Defence Forces Systems" "Authoritative Estonian Defence Forces systems providing data and functionality required by the selected services."

        tis = softwareSystem "Health Information System (TIS)" "Authoritative health information system accessed through TEHIK-managed interfaces and X-tee."

        notificationProviders = softwareSystem "Email/SMS Notification Providers" "Trusted external services used to deliver portal notifications."

        citizen -> portal.app "Uses to access defence-related services"
        administrator -> portal.app "Uses for permitted support and administration"
        auditor -> portal.app "Uses to review permitted audit and transparency information"

        portal.app -> portal.db "Reads from and writes portal-owned data"

        portal.app -> tara "Authenticates users via" "OIDC"
        portal.app -> kvkr "Reads and exchanges required defence-obligation data"
        portal.app -> defenceForces "Exchanges required defence-service workflow data"
        portal.app -> tis "Requests required health information through trusted interfaces"
        portal.app -> notificationProviders "Sends notification requests"
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
            relationship "Relationship" {
                thickness 4
            }
        }
    }

    configuration {
        scope softwaresystem
    }

}