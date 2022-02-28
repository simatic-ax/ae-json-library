USING AxUnit.Assert;
USING System.Strings;
USING Simatic.Ax.Conversion;
USING Simatic.Ax.Json;


{TestFixture}
Class UsingSerializer
    VAR PUBLIC
        doc : JsonDocument;
        cmpBuff : ARRAY[0..20] OF CHAR;

        str, s : STRING; 

        myBoolean : JsonBoolean := (Value := TRUE, Key := 'myBoolean');
        myInt : JsonInt := (Value := 1234, Key := 'myInt');
        myDint : JsonDInt := (Value := DINT#12345678, Key := 'myDint');
        myString : JsonString := (Value := 'this is my string', Key := 'myString');
        myObject : JsonObject := (Key := 'myObject');
    END_VAR

    {Test}
    METHOD PUBLIC Serialize_BOOLEAN
        doc.AddElement(myBoolean);
        doc.Serialize(doc.buffer);
        
        str := Arrays.ToString(doc.buffer, 0, 18);
        Equal(expected := '{"myBoolean": true}', actual := str);
    END_METHOD

    {Test}
    METHOD PUBLIC Serialize_INT
        doc.AddElement(myInt);
        doc.Serialize(doc.buffer);
        
        str := Arrays.ToString(doc.buffer, 0, 14);
        Equal(expected := '{"myInt": 1234}', actual := str);
    END_METHOD

    {Test}
    METHOD PUBLIC Serialize_DINT
        doc.AddElement(myDint);
        doc.Serialize(doc.buffer);
        
        str := Arrays.ToString(doc.buffer, 0, 19);
        Equal(expected := '{"myDint": 12345678}', actual := str);
    END_METHOD
    
    {Test}
    METHOD PUBLIC Serialize_STRING
        doc.AddElement(myString);
        doc.Serialize(doc.buffer);
        
        str := Arrays.ToString(doc.buffer, 0, 32);
        Equal(expected := '{"myString": "this is my string"}', actual := str);
    END_METHOD

    {Test}
    METHOD PUBLIC Serialize_INT_DINT
        doc.AddElement(myInt);
        doc.AddElement(myDint);
        doc.Serialize(doc.buffer);
        
        str := Arrays.ToString(doc.buffer, 0, 34);
        Equal(expected := '{"myInt": 1234, "myDint": 12345678}', actual := str);
    END_METHOD

    {Test}
    METHOD PUBLIC Serialize_NestedObject
        myObject.AddElement(myInt);
        myObject.AddElement(myDint);
        
        doc.AddElement(myBoolean);
        doc.AddElement(myObject);
        
        doc.Serialize(doc.buffer);
        
        str := Arrays.ToString(doc.buffer, 0, 67);
        Equal(expected := '{"myBoolean": true, "myObject": {"myInt": 1234, "myDint": 12345678}}', actual := str);
    END_METHOD

END_CLASS