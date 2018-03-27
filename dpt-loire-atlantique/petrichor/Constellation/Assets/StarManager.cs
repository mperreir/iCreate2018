using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;

public class StarManager : MonoBehaviour {

	List<GameObject> stars;

	// Use this for initialization
	void Start ()
	{
		stars = new List<GameObject>();
		GameObject prefab = Resources.Load("Star/StarPrefab", typeof(GameObject)) as GameObject;
		GameObject star;
		StreamReader dataFile = new StreamReader("Assets/Resources/soldats_memorial_virtuel.csv");
		string rawLine = dataFile.ReadLine();
		string[] dataLine;
		string residence = null;
		string grade = null;
		string profession = null;
		string naissance = null;
		string volontaire = null;
		int age = 0;
		int num = 0;
		int width = 0;
		bool firstLine = true;
		int i = 0;
		while (rawLine != null && i < 5000)
		{
			dataLine = rawLine.Split(';');
			if (firstLine)
			{
				width = dataLine.Length;
				firstLine = false;
			}
			else if (dataLine.Length == width)
			{
				System.Int32.TryParse(dataLine[0], out num);
				System.Int32.TryParse(dataLine[11], out age);
				if (dataLine[13] != "")
				{
					residence = dataLine[13];
				}
				if (dataLine[15] != "")
				{
					grade = dataLine[15];
				}
				if (dataLine[6] != "")
				{
					volontaire = dataLine[6];
				}
				if (dataLine[3] != "")
				{
					profession = dataLine[3];
				}
				if (dataLine[1] != "")
				{
					naissance = dataLine[1];
				}
				star = Instantiate(prefab);
				star.transform.SetParent(this.transform);
				star.name = num.ToString();
				star.GetComponent<StarScript>().num = num;
				star.GetComponent<StarScript>().age = age;
				star.GetComponent<StarScript>().residence = residence;
				star.GetComponent<StarScript>().grade = grade;
				star.GetComponent<StarScript>().profession = profession;
				star.GetComponent<StarScript>().naissance = naissance;
				star.GetComponent<StarScript>().volontaire = volontaire;
				star.transform.position = new Vector3(10-Random.value*20, 5-Random.value*10, Random.value*20);
				this.stars.Add(star);
				rawLine = dataFile.ReadLine();
				i++;
			}
		}
	}
	
	// Update is called once per frame
	void Update ()
	{
		
	}
}
