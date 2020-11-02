using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class NewBehaviourScript1 : MonoBehaviour
{
    [SerializeField]
    Canvas canvas;

    [SerializeField]
    RectTransform panelX;

    [SerializeField]
    RectTransform panelSquare;

    public void CanvasScalerReferenceResolution(string req)
    {
        var rs = req.Split(',');
        var (x, y) = (float.Parse(rs[0]), float.Parse(rs[1]));

        var scaler = canvas.GetComponent<CanvasScaler>();
        scaler.referenceResolution = new Vector2(x, y);
    }

    public void CanvasScalerReferenceMatch(string req)
    {
        var m = float.Parse(req);

        var scaler = canvas.GetComponent<CanvasScaler>();
        scaler.matchWidthOrHeight = m;
    }

    public void PanelSquareWidthAndHeight(string req)
    {
        var rs = req.Split(',');
        var (x, y) = (float.Parse(rs[0]), float.Parse(rs[1]));

        panelSquare.sizeDelta = new Vector2(x, y);
    }

    public void PanelXWidthAndHeight(string req)
    {
        var rs = req.Split(',');
        var (x, y) = (float.Parse(rs[0]), float.Parse(rs[1]));

        panelX.sizeDelta = new Vector2(x, y);
    }
}
