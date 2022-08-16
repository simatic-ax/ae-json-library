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
        step : Steps;
        deserializer : Deserializer;
        key : STRING;
        keyFound : BOOL;
        intValue : INT;
    END_VAR
    VAR_TEMP
        keyArray : ARRAY[0..1] OF STRING;
    END_VAR
    CASE step OF
        Steps#CreateDocument1:
            // Create Document 1st object model
            // Expected Value: {"myInt": 1234}
            doc.AddElement(myInt);
            doc.Serialize(doc.buffer);
            step := Steps#SerializeDocument1
            ;
        Steps#SerializeDocument1:
            // Serialize Document 1st object model1
            doc.Serialize(doc.buffer);
            step := Steps#ParseDocument1
            ;
        Steps#ParseDocument1:
            // Parse Document 1st object model
            deserializer.SetBuffer(REF(doc.buffer));
            key := 'myInt';
            keyFound := deserializer.TryParse(key, intValue);
            step := Steps#ResetJSonDocument1
            ;
        Steps#ResetJSonDocument1:
            // ResetJSonDocument 1st object model
            doc.Reset();
            step := Steps#CreateDocument2
            ;
        Steps#CreateDocument2:
            // Create Document 2nd object model (nested object)
            // Expected Value: {"myBoolean": true, "myObject": {"myInt": 1234, "myDint": 12345678}}
            myObject.AddElement(myInt);
            myObject.AddElement(myDint);
            doc.AddElement(myBoolean);
            doc.AddElement(myObject);
            step := Steps#SerializeDocument2
            ;
        Steps#SerializeDocument2:
            // Serialize Document 2nd object model including time meassurement
            measurement.Start();
            doc.Serialize(doc.buffer);
            timeOfOperations := measurement.Stop();
            inNanos1 := measurement.GetElapsedNanoseconds();
            step := Steps#ParseDocument2;
            ;
        Steps#ParseDocument2:
            // Parse Document 1st object model
            // Get Values from a nested element
            deserializer.SetBuffer(REF(doc.buffer));
            keyArray[0] := 'myObject';
            keyArray[1] := 'myInt';
            keyFound := deserializer.TryParse(keyArray, intValue);
            step := Steps#ResetJSonDocument2;
            ;
        Steps#ResetJSonDocument2:
            // ResetJSonDocument 2nd configuration
            doc.Reset();
            step := Steps#CreateDocument1;
            ;
    END_CASE;


END_PROGRAM

TYPE
    Steps : (
        CreateDocument1,
        SerializeDocument1,
        ParseDocument1,
        ResetJSonDocument1,
        CreateDocument2,
        SerializeDocument2,
        ParseDocument2,
        ResetJSonDocument2) := CreateDocument1;
END_TYPE
