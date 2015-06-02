# Portico-Estate
Docker implementation of the Open Source Facilities Managment System "Portico Estate"

Portico Estate is organized as a set of submodules - each with their own set of user permission-settings

    Helpdesk (Trouble Ticket module)
    Property (location) register - with drawing and document-archive(vfs)
    Generic hierarchical entity modelling that via a metadatabase provides features as:
        Equipment register with configurable custom sets of attributes per type
        Reports/registration of any kind
        Modeled as one of two options:
            A table per entity_category and a column per attribute. Ideal for a integration on table-level.
            An XML adapted EAV-model that allows infinite types of entities to be stored within the same table-structure without any need for changing the database-schema. Ideal for storing BIM/IFC information
    Vendor register (using Addressbook)
    Tenant register
    Project/workorder by email/pdf with ability to save workorders as templates for later use
        From vendors prizebook - or
        from templates - or
        by custom definition as (optional) tender for bidding based on (for the moment) norwegian building standards.
    Service agreements with prizebook with historical prizing per vendor
    Invoice handling
        Import from files (drop in filters)
        Approval per Role
            Janitor
            Supervisor
            Budget responsible
        Export to payment system / accounting system
    Rental management
    Booking system with public frontend and internal backend
    tracking of items across the system
    Generic support for JasperReports
    Interface enhanced by YUI
    SMS gateway (ported from playsms)
    Controller: Planned frequency based checklists related to locations and / or equipment type. Responsibilities are assigned to roles per location, and deviations are handled by the Trouble Ticket module
    Generic support for XMLRPC and SOAP


