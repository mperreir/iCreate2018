using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.IO;
using UnityEngine.UI;

public class StarManager : MonoBehaviour {

	private List<StarScript> stars;
	private List<GalaxyScript> galaxies;
	private List<string> residences;
	private List<string> professions;
	private List<string> volontaires;
	private List<string> grades;
	private List<string> naissances;
	private List<string> ages;
	private GameObject starsObject;
	private GameObject galaxiesObject;
	private int ActiveGalaxyIndex;

	public string criteria = "all";
	public float galaxyDensity = 200;
	public float galaxyMinSpeed = 10;
	public float galaxyMaxSpeed = 25;
	public float joinspeed = 2;
	public float minx = -10;
	public float maxx = 10;
	public float miny = -10;
	public float maxy = 10;
	public float minz = 0;
	public float maxz = 20;

	// Use this for initialization
	void Start ()
	{
		this.ActiveGalaxyIndex = 0;
		this.residences = new List<string>();
		this.professions = new List<string>();
		this.volontaires = new List<string>();
		this.grades = new List<string>();
		this.ages = new List<string>();
		this.naissances = new List<string>();
		stars = new List<StarScript>();
		galaxies = new List<GalaxyScript>();
		StarScript prefab = (Resources.Load("Star/StarPrefab", typeof(GameObject)) as GameObject).GetComponent<StarScript>();
		this.starsObject = new GameObject();
		this.starsObject.name = "stars";
		this.starsObject.transform.SetParent(this.transform);
		this.galaxiesObject = new GameObject();
		this.galaxiesObject.name = "galaxies";
		this.galaxiesObject.transform.SetParent(this.transform);
		StarScript star;
		StreamReader dataFile = new StreamReader(Application.streamingAssetsPath + "/Soldats.csv");
		string rawLine = dataFile.ReadLine();
		string[] dataLine;
		string residence, grade, profession, naissance, volontaire;
		int age, num, anaissance;
		int width = 0;
		bool firstLine = true;
		int i = 0;
		while (rawLine != null)
		{
			dataLine = rawLine.Split(';');
			if (firstLine)
			{
				width = dataLine.Length;
				firstLine = false;
			}
			else if (dataLine.Length == width)
			{
				age = 0;
				num = 0;
				System.Int32.TryParse(dataLine[0], out num);
				System.Int32.TryParse(dataLine[11], out age);
				if (age >= 16 && !this.ages.Contains(age.ToString()))
				{
					this.ages.Add(age.ToString());
				}
				residence = dataLine[13].ToLower();
				if (residence != "" && !this.residences.Contains(residence))
				{
					this.residences.Add(residence);
				}
				grade = dataLine[15].ToLower();
				if (grade != "" && !this.grades.Contains(grade))
				{
					this.grades.Add(grade);
				}
				volontaire = dataLine[6].ToLower();
				if (volontaire != "" && !this.volontaires.Contains(volontaire))
				{
					this.volontaires.Add(volontaire);
				}
				profession = dataLine[3].ToLower();
				if (profession != "" && !this.professions.Contains(profession))
				{
					this.professions.Add(profession);
				}
				naissance = dataLine[1].ToLower();
				if (naissance.Split('/').Length != 3 || naissance.Split('/')[2].Length != 4)
				{
					naissance = "";
				}
				else if (naissance.Split('/').Length == 3)
				{
					anaissance = 0;
					System.Int32.TryParse(naissance.Split('/')[2], out anaissance);
					if (anaissance >= 1902 || anaissance < 1860)
					{
						naissance = "";
					}
				}
				else
				{
					naissance = "";
				}
				if (naissance != "" && !this.naissances.Contains(naissance.Split('/')[2]))
				{
					this.naissances.Add(naissance.Split('/')[2]);
				}
				star = Instantiate(prefab);
				star.transform.SetParent(this.starsObject.transform);
				star.name = i.ToString();
				star.num = num;
				star.age = age;
				star.residence = residence;
				star.grade = grade;
				star.profession = profession;
				star.naissance = naissance;
				star.volontaire = volontaire;
				star.joinSpeed = this.joinspeed;
				star.transform.position = new Vector3(this.minx + Random.value * (this.maxx - minx), this.miny + Random.value * (this.maxy - miny), this.minz + Random.value * (this.maxz - minz));
				star.gameObject.SetActive(false);
				this.stars.Add(star);
				i++;
			}
			rawLine = dataFile.ReadLine();
		}
		dataFile.Close();
		this.ChangeCriteria(this.criteria);
	}

	void ChangeCriteria(string criteria)
	{
		int i, num;
		this.criteria = criteria;
		GalaxyScript galaxy, rootGalaxy, currentGalaxy;
		for (i = 0; i < this.stars.Count; i++)
		{
			this.stars[i].FreeStar(this.starsObject);
		}
		for (i = 0; i < this.galaxies.Count; i++)
		{
			Destroy(this.galaxies[i].gameObject);
		}
		this.galaxies.Clear();
		if (criteria == "all")
		{
			this.galaxies.Add(CreateGalaxy(this.stars.Count, "Ils sont morts pendant la guerre", this.galaxyDensity));
			this.galaxies[0].GetComponentInChildren<Text>().text = "";
			for (i = 0; i < this.stars.Count; i++)
			{
				this.stars[i].MoveTo(this.galaxies[0]);
			}
		}
		else if (criteria == "none")
		{
			for (i = 0; i < this.stars.Count; i++)
			{
				this.stars[i].FreeStar(this.starsObject.gameObject);
			}
		}
		else if (criteria == "residence")
		{
			
			num = this.stars.Count / this.residences.Count;
			rootGalaxy = CreateGalaxy(num, "On ne sait pas", this.galaxyDensity);
			this.galaxies.Add(rootGalaxy);
			rootGalaxy.GetComponentInChildren<Text>().text = "";
			for (i = 0; i < this.residences.Count; i++)
			{
				currentGalaxy = this.CreateGalaxy(num, this.residences[i], this.galaxyDensity);
				this.galaxies.Add(currentGalaxy);
				currentGalaxy.GetComponentInChildren<Text>().text = this.residences[i];
			}
			for (i = 0; i < this.stars.Count; i++)
			{
				galaxy = this.FindGalaxy(stars[i].residence);
				if (galaxy == null)
				{
					stars[i].MoveTo(rootGalaxy);
				}
				else
				{
					stars[i].MoveTo(galaxy);
				}
			}
		}
		else if (criteria == "profession")
		{

			num = this.stars.Count / this.professions.Count;
			rootGalaxy = CreateGalaxy(num, "On ne sait pas", this.galaxyDensity);
			this.galaxies.Add(rootGalaxy);
			rootGalaxy.GetComponentInChildren<Text>().text = "";
			for (i = 0; i < this.professions.Count; i++)
			{
				currentGalaxy = this.CreateGalaxy(num, this.professions[i], this.galaxyDensity);
				this.galaxies.Add(currentGalaxy);
				currentGalaxy.GetComponentInChildren<Text>().text = this.professions[i];
			}
			for (i = 0; i < this.stars.Count; i++)
			{
				galaxy = this.FindGalaxy(stars[i].profession);
				if (galaxy == null)
				{
					stars[i].MoveTo(rootGalaxy);
				}
				else
				{
					stars[i].MoveTo(galaxy);
				}
			}
		}
		else if (criteria == "grade")
		{

			num = this.stars.Count / this.grades.Count;
			rootGalaxy = CreateGalaxy(num, "On ne sait pas", this.galaxyDensity);
			this.galaxies.Add(rootGalaxy);
			rootGalaxy.GetComponentInChildren<Text>().text = "";
			for (i = 0; i < this.grades.Count; i++)
			{
				currentGalaxy = this.CreateGalaxy(num, this.grades[i], this.galaxyDensity);
				this.galaxies.Add(currentGalaxy);
				currentGalaxy.GetComponentInChildren<Text>().text = this.grades[i];
			}
			for (i = 0; i < this.stars.Count; i++)
			{
				galaxy = this.FindGalaxy(stars[i].grade);
				if (galaxy == null)
				{
					stars[i].MoveTo(rootGalaxy);
				}
				else
				{
					stars[i].MoveTo(galaxy);
				}
			}
		}
		else if (criteria == "naissance")
		{

			num = this.stars.Count / this.naissances.Count;
			rootGalaxy = CreateGalaxy(num, "On ne sait pas", this.galaxyDensity);
			this.galaxies.Add(rootGalaxy);
			rootGalaxy.GetComponentInChildren<Text>().text = "";
			for (i = 0; i < this.naissances.Count; i++)
			{
				currentGalaxy = this.CreateGalaxy(num, this.naissances[i], this.galaxyDensity);
				this.galaxies.Add(currentGalaxy);
				currentGalaxy.GetComponentInChildren<Text>().text = "né en " + this.naissances[i];
			}
			for (i = 0; i < this.stars.Count; i++)
			{
				if (stars[i].naissance != "")
				{
					galaxy = this.FindGalaxy(stars[i].naissance.Split('/')[2]);
				}
				else
				{
					galaxy = null;
				}
				if (galaxy == null)
				{
					stars[i].MoveTo(rootGalaxy);
				}
				else
				{
					stars[i].MoveTo(galaxy);
				}
			}
		}
		else if (criteria == "volontaire")
		{

			num = this.stars.Count / this.volontaires.Count;
			rootGalaxy = CreateGalaxy(num, "On ne sait pas", this.galaxyDensity);
			this.galaxies.Add(rootGalaxy);
			rootGalaxy.GetComponentInChildren<Text>().text = "";
			for (i = 0; i < this.volontaires.Count; i++)
			{
				currentGalaxy = this.CreateGalaxy(num, this.volontaires[i], this.galaxyDensity);
				this.galaxies.Add(currentGalaxy);
				if (this.volontaires[i] == "oui")
				{
					currentGalaxy.GetComponentInChildren<Text>().text = "volontaire";
				}
				else
				{
					currentGalaxy.GetComponentInChildren<Text>().text = "mobilisé";
				}
			}
			for (i = 0; i < this.stars.Count; i++)
			{
				galaxy = this.FindGalaxy(stars[i].volontaire);
				if (galaxy == null)
				{
					stars[i].MoveTo(rootGalaxy);
				}
				else
				{
					stars[i].MoveTo(galaxy);
				}
			}
		}
		else if (criteria == "age")
		{

			num = this.stars.Count / this.volontaires.Count;
			rootGalaxy = CreateGalaxy(num, "On ne sait pas", this.galaxyDensity);
			this.galaxies.Add(rootGalaxy);
			rootGalaxy.GetComponentInChildren<Text>().text = "";
			for (i = 0; i < this.ages.Count; i++)
			{
				currentGalaxy = this.CreateGalaxy(num, this.ages[i], this.galaxyDensity);
				this.galaxies.Add(currentGalaxy);
				currentGalaxy.GetComponentInChildren<Text>().text = this.ages[i] + " ans";
			}
			for (i = 0; i < this.stars.Count; i++)
			{
				galaxy = this.FindGalaxy(stars[i].age.ToString());
				if (galaxy == null)
				{
					stars[i].MoveTo(rootGalaxy);
				}
				else
				{
					stars[i].MoveTo(galaxy);
				}
			}
		}
		for (i = 0; i < this.galaxies.Count; i++)
		{
			this.galaxies[i].transform.GetChild(0).gameObject.SetActive(false);
		}
	}
	
	// Update is called once per frame
	void Update ()
	{
		
	}

	private GalaxyScript FindGalaxy(string tag)
	{
		int i;
		for (i = 0; i < galaxies.Count; i++)
		{
			if (galaxies[i].galaxyTag == tag)
			{
				return galaxies[i];
			}
		}
		return null;
	}

	private GalaxyScript CreateGalaxy(int num, string tag, float density)
	{
		GalaxyScript galaxy = Instantiate((Resources.Load("Galaxy/GalaxyPrefab", typeof(GameObject)) as GameObject).GetComponent<GalaxyScript>());
		galaxy.name = tag;
		galaxy.galaxyTag = tag;
		galaxy.radius = Mathf.Pow(num / density, 1/3F);
		galaxy.transform.position = new Vector3(this.minx + Random.value * (this.maxx - minx), this.miny + Random.value * (this.maxy - miny), this.minz + Random.value * (this.maxz - minz));
		galaxy.rotator = new Vector3(1 - Random.value * 2, 1 - Random.value * 2, 1 - Random.value * 2);
		galaxy.name = tag;
		galaxy.transform.SetParent(this.galaxiesObject.transform);
		galaxy.speed = this.galaxyMinSpeed + Random.value * (this.galaxyMaxSpeed - this.galaxyMinSpeed);
		this.galaxies.Add(galaxy);
		return galaxy;
	}

	public void NextCriteria()
	{
		string criteria = "all";
		if (this.criteria == "none" || this.criteria == "all")
		{
			criteria = "profession";
		}
		if (this.criteria == "age")
		{
			criteria = "grade";
		}
		else if (this.criteria == "grade")
		{
			criteria = "profession";
		}
		else if (this.criteria == "naissance")
		{
			criteria = "volontaire";
		}
		else if (this.criteria == "profession")
		{
			criteria = "residence";
		}
		else if (this.criteria == "residence")
		{
			criteria = "naissance";
		}
		else if (this.criteria == "volontaire")
		{
			criteria = "age";
		}
		this.ChangeCriteria(criteria);
		this.ActiveGalaxyIndex = Random.Range(0, this.galaxies.Count - 1);
	}

	private void DeScint()
	{
		int i;
		for (i = 0; i < this.stars.Count; i++)
		{
			this.stars[i].ScintActive = false;
		}
	}

	public void Scint()
	{
		int i;
		for (i = 0; i < this.stars.Count; i++)
		{
			this.stars[i].ScintActive = true;
		}
	}

	public void ResetStars()
	{
		int i;
		this.ChangeCriteria("all");
		for (i = 0; i < this.stars.Count; i++)
		{
			this.stars[i].gameObject.SetActive(false);
		}
		this.DeScint();
	}

    public void SpawnStars(int num)
    {
        ActivateStars(num);
    }

	public void ActivateStars(int num)
	{
		int i, n;
		for (i = 0; i < num; i++)
		{
			n = Random.Range(0, this.stars.Count - 1);
			this.stars[n].transform.position = new Vector3(this.minx + Random.value * (this.maxx - minx), this.miny + Random.value * (this.maxy - miny), this.minz + Random.value * (this.maxz - minz));
			if (this.stars[n].galaxy != null)
			{
				this.stars[n].transform.SetParent(this.starsObject.transform);
				this.stars[n].MoveTo(this.stars[n].galaxy);
			}
			this.stars[n].gameObject.SetActive(true);
		}
	}

	public GameObject NextGalaxy()
	{
		if (this.galaxies.Count == 0)
		{
			return null;
		}
		this.galaxies[this.ActiveGalaxyIndex].transform.GetChild(0).gameObject.SetActive(false);
		this.ActiveGalaxyIndex = (this.ActiveGalaxyIndex + 1) % this.galaxies.Count;
		this.galaxies[this.ActiveGalaxyIndex].transform.GetChild(0).gameObject.SetActive(true);
		return this.galaxies[this.ActiveGalaxyIndex].gameObject;
	}
}
