#if UNITY_IOS
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using UnityEditor.Build;
using UnityEditor.Build.Reporting;
using UnityEditor.Callbacks;
using UnityEditor.iOS.Xcode;

public class IOSPostProcessor : IPostprocessBuildWithReport
{
    public void OnPostprocessBuild(BuildReport report)
    {
        var summary = report.summary;
        var outputPath = summary.outputPath;
        var projectPath = outputPath + "/Unity-iPhone.xcodeproj/project.pbxproj";

        var pbx = new PBXProject();
        pbx.ReadFromFile(projectPath);

        var guidTarget = pbx.GetUnityFrameworkTargetGuid();

        var guidData = pbx.FindFileGuidByProjectPath("Data");
        var guidResPhase = pbx.GetResourcesBuildPhaseByTarget(guidTarget);
        pbx.AddFileToBuildSection(guidTarget, guidResPhase, guidData);
        
        pbx.SetBuildProperty(guidTarget, "BITCODE_GENERATION_MODE", "bitcode");

        pbx.WriteToFile(projectPath);
    }

    public int callbackOrder => 0;
}
#endif
