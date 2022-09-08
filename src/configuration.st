USING Simatic.Ax.Json;

CONFIGURATION MyConfiguration
    TASK Main (INTERVAL := T#1000ms, PRIORITY := 1);
    PROGRAM P1 WITH Main: MyProgram;
    VAR_GLOBAL
        ActiveStep : STRING;
        SerializedDocument1 : STRING;
        TimeCreationDocument1 : LINT;
        ParsedValue1 : INT;
        SerializedDocument2 : STRING;
        TimeCreationDocument2 : LINT;
        ParsedValue2 : DINT;
    END_VAR
END_CONFIGURATION
