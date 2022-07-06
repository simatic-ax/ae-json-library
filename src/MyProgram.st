USING Simatic.Ax.Conversion;
USING Simatic.Ax.Json;
USING Siemens.Simatic.S71500.Clocks;

PROGRAM MyProgram
    VAR_EXTERNAL
        str : STRING;
        inNanos1 : LINT;
        inNanos2 : LINT;
    END_VAR

    VAR
        measurement : RuntimeMeasurement;
        timeOfOperations : LTIME;
        

        doc : JsonDocument;
        cmpBuff : ARRAY[0..20] OF CHAR;
        myBoolean : JsonBoolean := (Value := TRUE, Key := 'myBoolean');
        myInt : JsonInt := (Value := 1234, Key := 'myInt');
        myDint : JsonDInt := (Value := DINT#12345678, Key := 'myDint');
        myObject : JsonObject := (Key := 'myObject');
    END_VAR

    VAR_TEMP

    END_VAR

    myObject.AddElement(myInt);
    myObject.AddElement(myDint);
    
    doc.AddElement(myBoolean);
    doc.AddElement(myObject);
    
    measurement.Start();
    doc.Serialize(doc.buffer);
    timeOfOperations := measurement.Stop();
    inNanos1 := measurement.GetElapsedNanoseconds();


    measurement.Start();
    // str := Arrays.ToString(doc.buffer, 0, 67);
    timeOfOperations := measurement.Stop();
    inNanos2 := measurement.GetElapsedNanoseconds();

END_PROGRAM
