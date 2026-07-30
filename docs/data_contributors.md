---
title: Contributors
layout: default
nav_order: 10
permalink: /data-contributors/
parent: Organizers & Contributors
---

# Alpha Contributors

<button class="contributor-toggle-all" type="button" aria-expanded="false">
  Expand all
</button>

## Academic

<div class="contributor-institutions">

<details class="contributor-institution">
  <summary>Carnegie Mellon University</summary>
  <div class="contributor-institution__body">
    <div>
      <h4>Contributors</h4>
      <ul>
        <li>Ken Nakamura</li>
        <li>Andrew Z. Li</li>
        <li>Yilin Wu</li>
        <li>Junwon Seo</li>
      </ul>
    </div>
    <div>
      <h4>PIs</h4>
      <ul>
        <li>Andrea Bajcsy</li>
      </ul>
    </div>
  </div>
</details>

<details class="contributor-institution">
  <summary>Mila / Université de Montréal</summary>
  <div class="contributor-institution__body">
    <div>
      <h4>Contributors</h4>
      <ul>
        <li>Albert Zhan</li>
        <li>Jesse Silverberg</li>
      </ul>
    </div>
    <div>
      <h4>PIs</h4>
      <ul>
        <li>Glen Berseth</li>
      </ul>
    </div>
  </div>
</details>

<details class="contributor-institution">
  <summary>National University of Singapore</summary>
  <div class="contributor-institution__body">
    <div>
      <h4>Contributors</h4>
      <ul>
        <li>Jiafei Duan</li>
      </ul>
    </div>
    <div>
      <h4>PIs</h4>
      <ul>
        <li>Jiafei Duan</li>
      </ul>
    </div>
  </div>
</details>

<details class="contributor-institution">
  <summary>Princeton University</summary>
  <div class="contributor-institution__body">
    <div>
      <h4>Contributors</h4>
      <ul>
        <li>Tenny Yin</li>
        <li>Mingtong Zhang</li>
        <li>Arya Paliwal</li>
        <li>Beining Han</li>
      </ul>
    </div>
    <div>
      <h4>PIs</h4>
      <ul>
        <li>Anirudha Majumdar</li>
        <li>Jia Deng</li>
        <li>Dhruv Shah</li>
      </ul>
    </div>
  </div>
</details>

<details class="contributor-institution">
  <summary>Stanford University</summary>
  <div class="contributor-institution__body">
    <div>
      <h4>Contributors</h4>
      <ul>
        <li>Perry Dong</li>
        <li>Kuo-Han Hung</li>
        <li>Zeyi Liu</li>
      </ul>
    </div>
    <div>
      <h4>PIs</h4>
      <ul>
        <li>Shuran Song</li>
        <li>Chelsea Finn</li>
      </ul>
    </div>
  </div>
</details>

<details class="contributor-institution">
  <summary>UC Berkeley</summary>
  <div class="contributor-institution__body">
    <div>
      <h4>Contributors</h4>
      <ul>
        <li>Jagdeep Bhatia</li>
        <li>Andrew Wagenmaker</li>
      </ul>
    </div>
    <div>
      <h4>PIs</h4>
      <ul>
        <li>Sergey Levine</li>
      </ul>
    </div>
  </div>
</details>

<details class="contributor-institution">
  <summary>University of Pennsylvania</summary>
  <div class="contributor-institution__body">
    <div>
      <h4>Contributors</h4>
      <ul>
        <li>Long Le</li>
        <li>Sagnik Anupam</li>
      </ul>
    </div>
    <div>
      <h4>PIs</h4>
      <ul>
        <li>Dinesh Jayaraman</li>
      </ul>
    </div>
  </div>
</details>

<details class="contributor-institution">
  <summary>University of Texas at Austin</summary>
  <div class="contributor-institution__body">
    <div>
      <h4>Contributors</h4>
      <ul>
        <li>Skand Peri</li>
      </ul>
    </div>
    <div>
      <h4>PIs</h4>
      <ul>
        <li>Roberto Martín-Martín</li>
      </ul>
    </div>
  </div>
</details>

<details class="contributor-institution">
  <summary>University of Toronto</summary>
  <div class="contributor-institution__body">
    <div>
      <h4>Contributors</h4>
      <ul>
        <li>Maria Attarian</li>
        <li>Yifan Ruan</li>
        <li>James Ross</li>
      </ul>
    </div>
    <div>
      <h4>PIs</h4>
      <ul>
        <li>Igor Gilitschenski</li>
        <li>Florian Shkurti</li>
      </ul>
    </div>
  </div>
</details>

<details class="contributor-institution">
  <summary>University of Washington</summary>
  <div class="contributor-institution__body">
    <div>
      <h4>Contributors</h4>
      <ul>
        <li>Jesse Zhang</li>
        <li>Vattanary Tevy</li>
        <li>Marius Memmel</li>
        <li>Chaoxiang Zhang</li>
        <li>Aaron Tsai</li>
        <li>Jinghao Liu</li>
        <li>Joshua Tran</li>
        <li>Rosario Scalise</li>
        <li>Yuzhi Fan</li>
      </ul>
    </div>
    <div>
      <h4>PIs</h4>
      <ul>
        <li>Dieter Fox</li>
        <li>Abhishek Gupta</li>
      </ul>
    </div>
  </div>
</details>

</div>

## Industry

<div class="contributor-institutions">

<details class="contributor-institution">
  <summary>Armnet</summary>
  <div class="contributor-institution__body">
    <div>
      <h4>Contributors</h4>
      <ul>
        <li>Ville Kuosmanen</li>
      </ul>
    </div>
  </div>
</details>

<details class="contributor-institution">
  <summary>Enatic</summary>
  <div class="contributor-institution__body">
    <div>
      <h4>Contributors</h4>
      <ul>
        <li>Yue Yin</li>
      </ul>
    </div>
  </div>
</details>

</div>

<script>
document.addEventListener("DOMContentLoaded", function () {
  var toggle = document.querySelector(".contributor-toggle-all");
  var institutions = Array.from(
    document.querySelectorAll(".contributor-institution")
  );

  if (!toggle || institutions.length === 0) return;

  function updateToggle() {
    var allExpanded = institutions.every(function (institution) {
      return institution.open;
    });

    toggle.textContent = allExpanded ? "Collapse all" : "Expand all";
    toggle.setAttribute("aria-expanded", allExpanded.toString());
  }

  toggle.addEventListener("click", function () {
    var shouldExpand = !institutions.every(function (institution) {
      return institution.open;
    });

    institutions.forEach(function (institution) {
      institution.open = shouldExpand;
    });

    updateToggle();
  });

  institutions.forEach(function (institution) {
    institution.addEventListener("toggle", updateToggle);
  });

  updateToggle();
});
</script>
