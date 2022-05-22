Shader "Unlit/Shader1"
{
    Properties
    {
        //_MainTex ("Texture", 2D) = "white" {}
        _ColorA ("ColorA", Color) = (1,1,1,1)
        _ColorB ("ColorB", Color) = (0,0,0,1)
        _ColorStart ("ColorStart", Range(0,1)) = 1
        _ColorEnd ("ColorEnd", Range(0,1)) = 0
        _Scale ("Scale", Float) = 1
        _Offset ("Offset", Float) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert //tell vertex shader its function name
            #pragma fragment frag //tell fragment shader its function name

            #include "UnityCG.cginc"

            float4 _ColorA;
            float4 _ColorB;
            float _ColorStart;
            float _ColorEnd;
            float _Scale;
            float _Offset;
            
            struct MeshData // per-vertex mesh data
            {
                float4 vertex : POSITION; // vertex position
                float3 normal : NORMAL;
                // float4 tangent : TANGENT;
                // float4 color : COLOR;
                float2 uv0 : TEXCOORD0; // uv0 coordinates
                // float2 uv1 : TEXCOORD1; // uv1 coordinates
            };

            struct Interpolators // vertex to fragment
            {
                float4 vertex : SV_POSITION; // clip space position
                float3 normal : TEXCOORD0; // doesn't relate to actual uv, can be what ever floats
                float2 uv : TEXCOORD1;
            };

            Interpolators vert (MeshData v)
            {
                Interpolators o; // output
                //o.vertex = v.vertex;
                o.vertex = UnityObjectToClipPos(v.vertex); // local space to clip space
                o.normal = v.normal; // UnityObjectToWorldNormal(v.normal); change to world normal
                o.uv = v.uv0; // (v.uv0+_Offset) * _Scale;
                return o;
            }

            // define Inverselerp function, doesn't care the direction
            float InverseLerp( float a, float b, float v)
            {
                return (v-a)/(b-a);
            }
            
            // float (32 bit float): everywhere
            // half (16 bit float): mostly used
            // fixed (lower precision) -1 to 1
            float4 frag (Interpolators i) : SV_Target
            {
                // float4 myValue;
                // float2 otherValue = myValue.xy; // swizzling, rgba, xyzw
                float t = saturate(InverseLerp(_ColorStart, _ColorEnd, i.uv.x)); // saturate: clamp into 0 to 1
                float4 outColor = lerp(_ColorA, _ColorB, t);
                return outColor;
            }
            ENDCG
        }
    }
}
