//
//  Config.swift
//  CloudKit person database
//

enum Config {
    /// iCloud container identifier.
    static let containerIdentifier = "iCloud.com.janhovland.Person"
}

/*
DEFINE SCHEMA

    RECORD TYPE Person (
        "___createTime" TIMESTAMP QUERYABLE SORTABLE,
        "___createdBy"  REFERENCE,
        "___etag"       STRING,
        "___modTime"    TIMESTAMP,
        "___modifiedBy" REFERENCE,
        "___recordID"   REFERENCE,
        name            STRING QUERYABLE SEARCHABLE SORTABLE,
        GRANT WRITE TO "_creator",
        GRANT CREATE TO "_icloud",
        GRANT READ TO "_world"
    );
*/
