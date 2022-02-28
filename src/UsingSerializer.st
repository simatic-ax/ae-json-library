USING AxUnit.Assert;
USING System.Strings;
USING Simatic.Ax.Conversion;
USING Simatic.Ax.Json;


{TestFixture}
Class UsingSerializer
    VAR Public
        doc : JsonDocument;
        cmpBuff : ARRAY[0..20] OF CHAR;

        e : JsonBoolean := (Value := true, Key := 'test');
        b : JsonString := (Value := 'my string value', Key := 'stringKey');
    END_VAR

    

END_CLASS