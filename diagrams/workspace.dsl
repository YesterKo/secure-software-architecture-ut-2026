workspace "Citizen Services Portal" "C4 architecture model for the Citizen Services Portal" {

    !identifiers hierarchical

    model {
        group "Trust boundary: Public internet (untrusted)" {
            citizen = person "Citizen / Resident" "Uses digital citizen services through a unified portal."
        }

        group "Trust boundary: Staff and oversight (privileged)" {
            administrator = person "Administrator / Helpdesk Staff" "Provides permitted support and performs authorized administrative tasks."

            auditor = person "Auditor / Oversight" "Reviews permitted audit and transparency information."
        }

        portal = softwareSystem "Citizen Services Portal" "Provides a unified digital entry point for interacting with digital services and registries." {
            group "Public-facing zone" {
                web = container "Web Application" "Provides the user-facing interface for citizens, support staff, and auditors. Holds no authoritative data." {
                    tags "Web"
                }
            }

            group "Internal application zone" {
                backend = container "Backend Application" "Provides portal business logic, authentication handling, authorization, workflow coordination, validation, document handling (malware scanning, signing coordination), notification initiation, audit event creation, and the API used by the Web Application."

                integration = container "Integration Service" "Isolates external-system integrations and handles system-specific communication, data mapping, and integration failures. Has no access to portal data stores."
            }

            group "Restricted data zone" {
                db = container "Portal Database" "Stores portal-owned application data such as preferences, workflow coordination state, notification metadata, and configuration." {
                    tags "Database"
                }

                documents = container "Document Store" "Stores uploaded documents until confirmed delivery to the responsible organization or retention expiry." {
                    tags "Store"
                }

                audit = container "Audit Store" "Stores security-relevant portal audit events append-only, with restricted access and integrity requirements." {
                    tags "Store"
                }
            }
        }

        group "Trust boundary: RIA" {
            tara = softwareSystem "State Authentication Service (TARA)" "External identity provider operated by RIA and used for strong authentication with supported Estonian eID methods."
        }

        group "Trust boundary: KRA" {
            kraStaff = person "KRA Staff" "Kaitseressursside Amet staff who process defence-obligation requests and issue summonses and decisions."

            kvkr = softwareSystem "Kaitseväekohustuslaste register (KVKR)" "Authoritative defence-obligation register operated by Kaitseressursside Amet (KRA)."
        }

        group "Trust boundary: Estonian Defence Forces" {
            edfStaff = person "Defence Forces Staff" "Estonian Defence Forces staff who process defence-service requests and decisions."

            defenceForces = softwareSystem "Estonian Defence Forces Systems" "Authoritative Defence Forces systems providing data and functionality to portal services."
        }

        group "Trust boundary: TEHIK" {
            tis = softwareSystem "Health Information System (TIS)" "Authoritative health information system accessed through TEHIK-managed interfaces."
        }

        group "Trust boundary: Third-party providers" {
            notificationProviders = softwareSystem "Email/SMS Notification Providers" "Trusted external services used to deliver portal notifications."
        }

        citizen -> portal.web "Uses to access citizen services" "HTTPS"
        administrator -> portal.web "Uses for permitted support and administration" "HTTPS"
        auditor -> portal.web "Uses to review permitted audit and transparency information" "HTTPS"

        kraStaff -> kvkr "Processes forwarded requests and issues summonses and decisions in"
        edfStaff -> defenceForces "Processes defence-service requests and decisions in"

        portal.web -> portal.backend "Requests portal data and operations from"

        portal.backend -> tara "Uses for user authentication" "OIDC"

        portal.backend -> portal.db "Reads from and writes portal-owned app data"
        portal.backend -> portal.documents "Stores and retrieves documents"
        portal.backend -> portal.audit "Appends audit events and reads permitted audit information"
        portal.backend -> notificationProviders "Sends notification requests without sensitive content"

        portal.backend -> portal.integration "Requests external data and operations via"

        portal.integration -> kvkr "Exchanges required defence-obligation data" "X-tee (assumed)"
        portal.integration -> defenceForces "Exchanges required defence-service workflow data" "X-tee (assumed)"
        portal.integration -> tis "Requests required health information" "X-tee"
    }

    views {
        systemContext portal "C4Context" {
            include *
            include kraStaff edfStaff
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
            element "Group" {
                color #c0392b
                stroke #c0392b
                strokeWidth 3
                fontSize 22
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
