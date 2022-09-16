USING Simatic.Ax.Json;
{TestFixture}
CLASS TestMyProgram
    VAR
        timeOfOperations : LTIME;
        doc : JsonDocument;
        cmpBuff : ARRAY[0..20] OF CHAR;
        buffer : ARRAY[0..999] OF CHAR;
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
    {Test}
    METHOD PUBLIC MyTestMethod
        VAR_TEMP
            i : DINT;
        END_VAR
        
        FOR i := 1 TO 10000 DO
            this.MyProgram();
        END_FOR;
        
    END_METHOD
    
    METHOD PUBLIC MyProgram

        VAR_TEMP
            keyArray : ARRAY[0..1] OF STRING;
        END_VAR
        CASE step OF
            Steps#CreateDocument1:
                // Create Document 1st object model
                // Expected Value: {"myInt": 1234}
                doc.AddElement(myInt);
                doc.Serialize();
                step := Steps#SerializeDocument1
                ;
            Steps#SerializeDocument1:
                // Serialize Document 1st object model1
                doc.Serialize();
                step := Steps#ParseDocument1
                ;
            Steps#ParseDocument1:
                // Parse Document 1st object model
                deserializer.SetBuffer(REF(buffer));
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
                doc.Serialize();
                step := Steps#ParseDocument2;
                ;
            Steps#ParseDocument2:
                // Parse Document 1st object model
                // Get Values from a nested element
                deserializer.SetBuffer(REF(buffer));
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
    END_METHOD
END_CLASS