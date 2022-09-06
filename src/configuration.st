USING Simatic.Ax.Json;
CONFIGURATION MyConfiguration
    TASK Main(Priority := 1);
    PROGRAM P1 WITH Main: MyProgram;

    VAR_GLOBAL
        str : STRING;
        inNanos1 : LINT;
        inNanos2 : LINT;
    END_VAR
    
END_CONFIGURATION