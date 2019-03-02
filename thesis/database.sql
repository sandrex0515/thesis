create database thesis;

grant usage, select on all sequences in schema public to sandrex;

create table profile(
    id serial primary key,
    name varchar(255) NOT NULL,
    password varchar(255) NOT NULL,
    email varchar(255) NOT NULL,
    address varchar(255) NOT NULL,
    contact varchar(255) NOT NULL
);

create table admin(
    id serial primary key,
    name varchar(255) NOT NULL,
    password varchar(255) NOT NULL,
    email varchar(255) NOT NULL,
    address varchar(255) NOT NULL,
    contact varchar(255) NOT NULL
);

create table adminpic(
    id int references profile(id),
    path varchar(255) NOT NULL
);

create table userpic(
    id int references profile(id),
    path varchar(255) NOT NULL
);
alter table userpic drop column id;
alter table userpic add column user_id numeric;
alter table userpic owner to sandrex;

create table item(
    id serial primary key,
    item varchar(255) unique NOT NULL,
    description varchar(255) NOT NULL,
    price numeric NOT NULL,
    type varchar(255) NOT NULL,
    item_id numeric unique NOT NULL,
    create_at timestamp with time zone DEFAULT NOW();
);
alter table item add column archived boolean default false;

create table itempic(
    id int references item(id),
    path varchar(255) NOT NULL,
    date date
);

create table stock(
    -- id int references item(id),
    stock_id numeric,
    quantity numeric
);

create table cart(
    id int references profile(id),
    item varchar(255) NOT NULL,
    price numeric NOT NULL,   
    ord_id numeric unique NOT NULL
);

create table pending(
    name varchar(255) NOT NULL,
    item varchar(255) NOT NULL,
    price varchar(255) NOT NULL,
    address varchar(255) NOT NULL,
    contact varchar(255) NOT NULL
);
alter table pending add column date timestamp with time zone default now();
alter table pending add column ord_id int references cart(ord_id);

create table checked(
    name varchar(255) NOT NULL,
    item varchar(255) NOT NULL,
    price varchar(255) NOT NULL,
    address varchar(255) NOT NULL,
    contact varchar(255) NOT NULL
);

create table delivery(
    name varchar(255) NOT NULL,
    item varchar(255) NOT NULL,
    price varchar(255) NOT NULL,
    address varchar(255) NOT NULL,
    contact varchar(255) NOT NULL
);
    alter table delivery add column date timestamp with time zone default now();
    alter table delivery add column ord_id numeric unique not null;    

create table delivered(
    name varchar(255) NOT NULL,
    item varchar(255) NOT NULL,
    price varchar(255) NOT NULL,
    address varchar(255) NOT NULL,
    contact varchar(255) NOT NULL
);
alter table delivered add column date timestamp with time zone default now();
alter table delivered add column ord_id numeric unique not null;

    create table tbluser(
    id serial primary key, 
    name text unique not null, 
    bday varchar, 
    gender text, 
    address varchar, 
    email varchar, 
    password varchar
    );
    alter table tbluser owner to sandrex;
    alter table tbluser add column created_at timestamp with time zone default now();
    alter table tbluser add column archived boolean default false;
    create unique index constraint_name on tbluser (email);
    alter table tbluser add column contact varchar not null;

create table sales(
    id serial primary key,
    sales numeric,
    year numeric
);
create table recommend(
item_id int references item(item_id), 
date timestamp with time zone default now()
);  
alter table recommend drop column item_id;
alter table recommend add column item_id;


create table search(
    id numeric, 
    views numeric
    );
alter table search owner to sandrex;
alter table search drop column id;
alter table search add column id numeric unique;
alter table search add column id_search numeric unique;

function fetch_er22() {
      
        if ($scope.filter.type.length > 0) {
            $scope.filter.type = $scope.filter.type[0].name;
        }
        var promise = EmployeesFactory.get_er2($scope.filter);
        promise.then(function (data) {
            $scope.form.data = data.data.result;
            $scope.form.status1 = true;
        })   
        .then(null, function(data){
           $scope.form.status1 = false;
        });
    }




       $title = $data['searchstring'];
        $type = $data['type'];
        $title1 = $data['title'];
        $where = "";
        if ($title) {
            $where .= "AND name ILIKE '%".$title."%'";
        }
        if ($type) {
            $where .= "AND empname = '".$type."'";
        }
        if($title1) {
            $where .= "AND position = '".$title1."'";
        }
          $sql = <<<EOT
            select
            id,
            philno,
            name,
            address,
            email,
            position,
            salary,
            empno,
            empname,
            empprev,
            empdate,
            effdate,
            created_at::timestamp(0)
            from er2 
            where archived = 'f'
            $where
            order by created_at DESC




require_once('../connect.php');
require_once('../../CLASSES/Payroll.php');
$data = array();
foreach($_POST as $k=>$v){
	$data[$k]= $v;
}

$class = new Payroll($data);
$datas = $class->get_er2_csv($data);
$header = '#, Philhealth SSS/GSIS Number, Name, Email Address, Position, Salary,Employer No., Name of Employer/Firm, Previous Employer, Date of Employment, Eff. Date Coverage';
$subheader = ' , , , , , ';
$count = 1;
$body = '';
$total = '';

foreach($datas['result'] as $k => $v) {
	$body .= $count.','
	        .$v['philno'].','
	        .$v['name'].','
			.$v['email'].','
			.$v['position'].','
			.$cirr.round($v['salary'],2).','
			.$v['empno'].','
			.$v['empname'].','
			.$v['empprev'].','
			.$v['empdate'].','
			.$v['effdate']."\n";
			$count++;
}

$count-=1;
$total = ' , Total Employee ,'.$count.' ';

$filename = "er2_report".date('Ymd_His').".csv";
header ("Content-type: application/octet-stream");
header ("Content-Disposition: attachment; filename=".$filename);
echo $header."\n".$subheader."\n".$body."\n\n".$total;

app.controller('Employees', function (
    $scope,
    SessionFactory,
    EmployeesFactory,
    LeaveFactory,
    ngDialog,
    FileUploader,
    PagerService,
    cfpLoadingBar,
    FileUploader,
    $timeout,
    md5,
    DefaultvaluesFactory,
    EducationFactory
) {

    $scope.employer_details = {};

    $scope.employer_details = {
        name: '',
        tin: '',
        rdo: '',
        add: '',
        zip: '',
        data: {},
        status: false,
        sss: '',
        phil: '',
        pagibig: '',
        esignature: '',
        employee_name_signature: ''

    };
    $scope.pk = '';
    $scope.profile = {};
    $scope.filter = {};
    $scope.employee = {
        school_type: ''
    };
    $scope.filter.status = 'Active';
    $scope.filter.max_count = "10";

    $scope.uploader = {};
    $scope.uploader.queue = {};

    $scope.er2 = {};
    $scope.titles = {};
    $scope.department = {};
    $scope.level_title = {};
    $scope.team_title = {};
    $scope.groupings = {};
    $scope.subcompany = {};
    $scope.branch = {};
    $scope.educ_ile = {};
    $scope.form = {};

    $scope.hremployee = [];
    $scope.hrnotify = [];
    $scope.addDocuDisabled = true;


    $scope.employee = {};
    $scope.employee.seminar_training = [];
    $scope.leave_types = [];
    $scope.employees = {};
    $scope.time_employee = {};
    $scope.employees.count = 0;
    $scope.employees.filters = {};
    $scope.employeesheet_data = [];
    $scope.employee.education = [];


//John Dee 
    $scope.employee.government = [];
    $scope.notEmpty={};
    $scope.id = {};

    $scope.employment_type = {};
    $scope.employee_status = {};
    $scope.rate_type = {};
    $scope.pay_period = {};
    $scope.allowance_type = {};
    $scope.get_leave_pm = {};
    $scope.loan_types = {};

    $scope.document_supporting_document = "";
    $scope.documentee_upload = "";
    $scope.document_name = "";

    $scope.dependent_full_name = "";
    $scope.dependent_relationship = "";
    $scope.dependent_birth_date = "";
    $scope.dependent_supporting_document = "";

    $scope.allowance_types = "";
    $scope.allowance_amount = "";

    $scope.loan_type = "";
    $scope.loan_amount = "";

    $scope.leave_type = "";
    $scope.leave_amount = "";
    $scope.totalactive = 0;

    $scope.items = [];
    console.log($scope.employees.filters.er2);
    $scope.localLang = {
        selectAll: "Tick all",
        selectNone: "Tick none",
        reset: "Undo all",
        search: "Search for Name or Employee ID",
        nothingSelected: "None selected"         //default-label is deprecated and replaced with this.
    }

    $scope.modal = {};
    $scope.modal_remarks = {};
    $scope.level_class = 'orig_width';
    $scope.show_hours = false;
    
    $scope.tab = {
        personal: true,
        education: false,
        company: false,
        compensation: false,
        government: false
    };
    $scope.modal1 = {};
    $scope.current = {
        personal: 'current',
        education: '',
        company: '',
        compensation: '',
        government: ''
    };

    $scope.genders = [
        { pk: '1', gender: 'Male' },
        { pk: '2', gender: 'Female' }
    ];
    $scope.civils = [
        { pk: '1', civilstatus: 'Married' },
        { pk: '2', civilstatus: 'Single' },
        { pk: '3', civilstatus: 'Divorced' },
        { pk: '4', civilstatus: 'Living Common Law' },
        { pk: '5', civilstatus: 'Widowed' }
    ];

    $scope.year_dates = [{ year: '1899' }];

    var first_date = 1900;
    for (var i = $scope.year_dates.length; i < 150; i++) {
        first_date = first_date + 1;
        $scope.year_dates.push({
            year: first_date.toString()
        });
    }

    $scope.pager = {};
    $scope.setPage = setPage;
    $scope.current_page = 1;
    $scope.work = {
        monday: '',
        tuesday: '',
        wednesday: '',
        thursday: '',
        friday: '',
        saturday: '',
        sunday: ''
    };
    $scope.compensation = {
        group1: '',
        group2: '',
        group3: '',
        group4: '',
        group5: '',
        group6: '',
        pk: ''
    };
    $scope.disp_employees = {};
    $scope.compensation_status = false;
    $scope.loan_date_issued = "";
    $scope.loan_start_in_month = "";
    $scope.loan_start_in_year = "";
    $scope.amortization = 0;
    $scope.number_boom = 0;
    $scope.autodata = {};
    $scope.er2 = {};
    get_employer_details();
    init();
    fetch_er2();
    fetch_er2emp();


    
    $scope.show_er2 = function(){
        fetch_er2();
        fetch_er22();
        fetch_er222();
    }
    $scope.show_er22 = function(){
        fetch_er2();
        fetch_er22();
        fetch_er222();
        
    }
    $scope.show_er222 = function(){
        fetch_er2();
        fetch_er22();
        fetch_er222();
    }
    $scope.setPage = function(p){
		$scope.current_page = p;

		setPage();
	}

	function setPage() {
		if($scope.current_page < 1){
			//we should add 1 because once you click
			//the pagination's previous button, current page
			//will be deducted by 1
			$scope.current_page++;
		}
		else if($scope.current_page > $scope.pager.totalPages){
			//we should deduct 1 because once you click
			//the pagination's next button, current page
			//will be added by 1
			$scope.current_page--;
		}
		else {
			// get pager object from service
			$scope.pager = PagerService.GetPager($scope.employees.data.length, $scope.current_page, parseInt($scope.filter.max_count));

			// get current page of items
			$scope.items = $scope.employees.data.slice($scope.pager.startIndex, $scope.pager.endIndex + 1);
		}
	}

	$scope.paginateLeft = function(){
		$scope.current_page--;
		if($scope.current_page < 1){
			$scope.current_page = 1;
		}

		setPage();
	}
	$scope.paginateRight = function(){
		$scope.current_page++;

		if($scope.current_page > $scope.employees.data.length){
			$scope.current_page = $scope.employees.data.length
		}

		setPage();
	}
	

    function init() {
        var promise = SessionFactory.getsession();
        promise.then(function (data) {
            var _id = md5.createHash('pk');
            $scope.pk = data.data[_id];
            get_profile();
        })
            .then(null, function (data) {
                window.location = './login.html';
            });
    }

    $scope.change_tab = function (tab) {
        for (var i in $scope.tab) {
            $scope.tab[i] = false
            $scope.current[i] = '';
        }

        $scope.tab[tab] = true;
        $scope.current[tab] = 'current';
        if ($scope.current.compensation == 'current') {
            $scope.number_boom = 1;
        }
    }

    function get_profile() {
        $scope.profile.counterchecker = 0;
        var filters = {
            'pk': $scope.pk
        };

        var promise = EmployeesFactory.profile(filters);
        promise.then(function (data) {
            $scope.profile = data.data.result[0];
            $scope.profile.details = JSON.parse($scope.profile.details);
            $scope.profile.leave_balances = JSON.parse($scope.profile.leave_balances);
            $scope.profile.permission = JSON.parse($scope.profile.permission);
            if ($scope.profile.employee_name != '' && $scope.profile.employee_name != null && $scope.profile.employee_name != undefined) {
                $scope.profile.fullname = $scope.profile.employee_name;
                $scope.profile.counterchecker = 1;
            } else {
                $scope.profile.fullname = $scope.profile.details.personal.first_name + " " + $scope.profile.details.personal.last_name;
                $scope.profile.counterchecker = 0;
            }
            DEFAULTDATES();
            get_positions();
            get_department();
            get_levels();
            get_teams();
            get_supervisors();
            fetch_department();
            fetch_levels();
            fetch_titles();
            leave_types();
            get_employment_type();
            get_employment_statuses();
            get_rate_type();
            get_pay_period();
            get_allowance_type();
            get_leave_pm();
            loan_types();
            get_work_days();
            employees();
            get_sub();
            get_branch();
            get_educ();



        })
    }
    function get_educ(){
        $scope.educ_ile.status = false;
        $scope.educ_ile.data= '';
        if ($scope.filter.status == 'Active')
        {
            $scope.filter.archived = 'f';
        }
        else
        {
            $scope.filter.archived = 't';
        }
        var promise = EducationFactory.get_level($scope.filter);
        promise.then(function(data){
            $scope.educ_ile.status = true;
            $scope.educ_ile.data = data.data.result;
            var count = data.data.result.length;
            if (count==0) {
                $scope.educ_ile.count="";
            }
            else{
                $scope.educ_ile.count="Total: " + count;
            }
        })
        .then(null, function(data){
            $scope.educ_ile.status = false;
            $scope.educ_ile.count="";
        });
    }

    function DEFAULTDATES() {
        var today = new Date();

        var dd = today.getDate();
        var mm = today.getMonth() + 1;
        var yyyy = today.getFullYear();

        if (dd < 10) {
            dd = '0' + dd
        }

        if (mm < 10) {
            mm = '0' + mm
        }

        today = yyyy + '-' + mm + '-' + dd;

        $scope.filter.date_from = new Date(yyyy + '-' + mm + '-01');
        $scope.filter.date_to = new Date();

    }

    function getMonday(d) {
        var d = new Date(d);
        var day = d.getDay(),
            diff = d.getDate() - day + (day == 0 ? -6 : 1);

        var new_date = new Date(d.setDate(diff));
        var dd = new_date.getDate();
        var mm = new_date.getMonth() + 1;
        var yyyy = new_date.getFullYear();

        if (dd < 10) {
            dd = '0' + dd
        }

        if (mm < 10) {
            mm = '0' + mm
        }

        var monday = yyyy + '-' + mm + '-' + dd;

        return monday;
    };


    $scope.employee.documents = {};

    $scope.add_document = function () {
        var d = new Date();
        var dd = ('0' + d.getDate()).slice(-2);
        var mm = ('0' + (d.getMonth() + 1)).slice(-2);
        var yyyy = d.getFullYear();
        var date_today = mm + '-' + dd + '-' + yyyy;
        $scope.employee.documents.push({
            document_name : this.document_name,
            document_supporting_document : this.documentee_upload,
            document_date_created : date_today
        });

        $scope.addDocuDisabled = true;

        $scope.employee.upload_documents = true;

        // console.log($scope.documentee_upload);

        // console.log($scope.employee.documents);
    };

    $scope.show_employees = function () {

        employees();
        employees2();

    };
    $scope.show_employees2 = function () {
        employees();

        employees2();
    };

    function employees2() {
        cfpLoadingBar.start();
        if ($scope.filter.titles.length > 0) {
            $scope.filter.title = $scope.filter.titles[0].pk;
        }
        $scope.filter.archived = 'false';
        var promise = EmployeesFactory.fetch_all($scope.filter);
        promise.then(function (data) {
            $scope.employees.status = true;
            var a = data.data.result;
            var ticked=false;
            for (var i in a) {
                if(a[i].subcompany == ''){
                    // a[i].company_name = a[i].company_name;
                    a[i].subcompanyChecker = false;
                }
                else if(a[i].subcompany == null){
                    // a[i].company_name = a[i].company_name;
                    a[i].subcompanyChecker = false;
                }
                else if(a[i].subcompany == undefined){
                    // a[i].company_name = a[i].company_name;
                    a[i].subcompanyChecker = false;
                }
                else{
                    // a[i].company_name = a[i].subcompany;
                    a[i].subcompanyChecker = true;
                }

                if (a[i].archived == "f" && a[i].level != "Intern") {
                    $scope.totalactive += 1;
                }
                if (a[i].details != '' || a[i].details != null || a[i].details != undefined) {
                    a[i].details = JSON.parse(a[i].details);
                }
                for (var l in $scope.level_title.data) {
                    if (a[i].details.company.levels_pk == $scope.level_title.data[l].pk) {
                        a[i].level = $scope.level_title.data[l].level_title;
                        a[i].groupings = $scope.level_title.data[l].groupings;
                    }
                }
                for (var v in $scope.department.data) {
                    if (a[i].details.company.departments_pk == $scope.department.data[v].pk) {
                        a[i].department = $scope.department.data[v].department;
                    }
                }
                for (var w in $scope.titles.data) {
                    if (a[i].details.company.titles_pk == $scope.titles.data[w].pk) {
                        a[i].title = $scope.titles.data[w].title;
                    }
                }
                if(a[i].archived=='f')
                {
                    $scope.hremployee.push({
                        pk: a[i].pk,
                        name: a[i].details.personal.last_name + ", " + a[i].details.personal.first_name + " " + a[i].details.personal.middle_name,
                        id: a[i].employee_id,
                        business_email_address: a[i].details.company.business_email_address,
                        ticked: ticked
                    });
                }
            }
            $scope.employees.data = a;
            $scope.employees.count = data.data.result.length;
            setPage();

            cfpLoadingBar.complete();

        })
            .then(null, function (data) {
                $scope.employees.status = false;

                cfpLoadingBar.complete();
            });
    }
    function employees() {
        cfpLoadingBar.start();

        $scope.filter.archived = 'false';
        var promise = EmployeesFactory.fetch_all($scope.filter);
        promise.then(function (data) {
            $scope.employees.status = true;
            var a = data.data.result;
            var ticked=false;
            for (var i in a) {
                if(a[i].subcompany == ''){
                    // a[i].company_name = a[i].company_name;
                    a[i].subcompanyChecker = false;
                }
                else if(a[i].subcompany == null){
                    // a[i].company_name = a[i].company_name;
                    a[i].subcompanyChecker = false;
                }
                else if(a[i].subcompany == undefined){
                    // a[i].company_name = a[i].company_name;
                    a[i].subcompanyChecker = false;
                }
                else{
                    // a[i].company_name = a[i].subcompany;
                    a[i].subcompanyChecker = true;
                }

                if (a[i].archived == "f" && a[i].level != "Intern") {
                    $scope.totalactive += 1;
                }
                if (a[i].details != '' || a[i].details != null || a[i].details != undefined) {
                    a[i].details = JSON.parse(a[i].details);
                }
                for (var l in $scope.level_title.data) {
                    if (a[i].details.company.levels_pk == $scope.level_title.data[l].pk) {
                        a[i].level = $scope.level_title.data[l].level_title;
                        a[i].groupings = $scope.level_title.data[l].groupings;
                    }
                }
                for (var v in $scope.department.data) {
                    if (a[i].details.company.departments_pk == $scope.department.data[v].pk) {
                        a[i].department = $scope.department.data[v].department;
                    }
                }
                for (var w in $scope.titles.data) {
                    if (a[i].details.company.titles_pk == $scope.titles.data[w].pk) {
                        a[i].title = $scope.titles.data[w].title;
                    }
                }
                if(a[i].archived=='f')
                {
                    $scope.hremployee.push({
                        pk: a[i].pk,
                        name: a[i].details.personal.last_name + ", " + a[i].details.personal.first_name + " " + a[i].details.personal.middle_name,
                        id: a[i].employee_id,
                        business_email_address: a[i].details.company.business_email_address,
                        ticked: ticked
                    });
                }
            }
            $scope.employees.data = a;
            $scope.employees.count = data.data.result.length;
            setPage();

            cfpLoadingBar.complete();

        })
            .then(null, function (data) {
                $scope.employees.status = false;

                cfpLoadingBar.complete();
            });
    }

    $scope.setPage = function (p) {
        $scope.current_page = p;
        setPage();
    }

    function setPage() {
        if ($scope.current_page < 1) {

            $scope.current_page++;
        }
        else if ($scope.current_page > $scope.pager.totalPages) {

            $scope.current_page--;
        }
        else {

            $scope.pager = PagerService.GetPager($scope.employees.data.length, $scope.current_page, parseInt($scope.filter.max_count));


            $scope.items = $scope.employees.data.slice($scope.pager.startIndex, $scope.pager.endIndex + 1);
        }
    }

    $scope.paginateLeft = function () {
        $scope.current_page--;
        if ($scope.current_page < 1) {
            $scope.current_page = 1;
        }

        setPage();
    }
    $scope.paginateRight = function () {
        $scope.current_page++;

        if ($scope.current_page > $scope.employees.data.length) {
            $scope.current_page = $scope.employees.data.length
        }

        setPage();
    }

    function get_positions() {
        var promise = EmployeesFactory.get_positions();
        promise.then(function (data) {
            $scope.titles.data = data.data.result;
        })
            .then(null, function (data) {

            });
    }
    function get_employer_details() {
        
        var filters = {
            'name': 'employer_settings'
        };
        var promise = DefaultvaluesFactory.get_employer_details(filters);
        promise.then(function (data) {
            $scope.employer_details.status = true;
            $scope.employer_details.data = data.data.result[0];
            var details = JSON.parse($scope.employer_details.data.details);
            $scope.employer_details.sss = details.sss;
            $scope.employer_details.pagibig = details.pagibig;
            $scope.employer_details.tin = details.tin;
            $scope.employer_details.name = details.name;
            $scope.employer_details.phil = details.phil;
            $scope.employer_details.rdo = details.rdo;
            $scope.employer_details.zip = details.zip;
            $scope.employer_details.add = details.add;
            $scope.employer_details.esignature = details.esignature;
            $scope.employer_details.employee_name_signature = details.employee_name_signature;
        }).then(null, function (data) {
            $scope.employer_details.status = false;
        });
    }

    function get_department() {
        var filter = {
            archived: false
        }

        var promise = EmployeesFactory.get_department(filter);
        promise.then(function (data) {
            $scope.department.data = data.data.result;
        })
            .then(null, function (data) {

            });
    }

    function get_allowance_type() {
        var promise = EmployeesFactory.get_allowance_type();
        promise.then(function (data) {
            $scope.allowance_type.data = data.data.result;

        })
            .then(null, function (data) {

            });
    }

    function get_levels() {
        var promise = EmployeesFactory.get_levels();
        promise.then(function (data) {
            $scope.level_title.data = data.data.result;
        })
            .then(null, function (data) {

            });
    }


    function get_teams(){
        var promise = EmployeesFactory.get_teams();
        promise.then(function(data){
            $scope.team_title.data = data.data.result;
        })
        .then(null, function(data){

        });
    }

    function get_supervisors() {
        var promise = EmployeesFactory.get_supervisors();
        promise.then(function (data) {
            $scope.employees.supervisors = data.data.result;
        })
            .then(null, function (data) {

            });
    }

    function leave_types() {
        var filter = {
            archived: false
        };
        $scope.leave_types.data = [];
        var promise = LeaveFactory.get_leave_types(filter);
        promise.then(function (data) {
            $scope.leave_types.status = true;
            $scope.leave_types.data = data.data.result;
        })
            .then(null, function (data) {

            });
    }

    function get_employment_type() {
        var promise = EmployeesFactory.get_employment_type();
        promise.then(function (data) {
            $scope.employment_type.data = data.data.result;
        })
            .then(null, function (data) {

            });
    }

    function get_employment_statuses() {
        var promise = EmployeesFactory.get_employment_statuses();
        promise.then(function (data) {
            $scope.employee_status.data = data.data.result;
        })
            .then(null, function (data) {

            });
    }

    function get_rate_type() {
        var promise = EmployeesFactory.get_rate_type();
        promise.then(function (data) {
            $scope.rate_type.data = data.data.result;
        })
            .then(null, function (data) {

            });
    }

    function get_pay_period() {
        var promise = EmployeesFactory.get_pay_period();
        promise.then(function (data) {
            $scope.pay_period.data = data.data.result;
        })
            .then(null, function (data) {

            });
    }

    function get_leave_pm() {
        var promise = EmployeesFactory.get_leave_pm();
        promise.then(function (data) {
            $scope.get_leave_pm.data = data.data.result;
        })
            .then(null, function (data) {

            });
    }

    function loan_types() {
        var promise = EmployeesFactory.loan_types();
        promise.then(function (data) {
            $scope.loan_types.data = data.data.result;

        })
            .then(null, function (data) {

            });
    }

    function get_sub() {
        var filter = {
            archived: false
        }
        var promise = EmployeesFactory.get_sub(filter);
        promise.then(function (data) {
            $scope.subcompany.data = data.data.result;
        }).then(null, function (data) {
        });
    }

    function get_branch() {
        var filter = {
            archived: false
        }
        var promise = EmployeesFactory.get_branch(filter);
        promise.then(function (data) {
            $scope.branch.data = data.data.result;
        }).then(null, function (data) {
        });
    }



    $scope.export_employees = function () {
        window.open('./FUNCTIONS/Timelog/employees_export.php?pk=' + $scope.filter.pk + '&datefrom=' + $scope.filter.datefrom + "&dateto=" + $scope.filter.dateto);
    }


    $scope.delete_employees = function (k) {

        var date = new Date();
        $scope.modal = {
            title: '',
            message: 'Deactivate Accounts',
            save: 'Deactivate',
            close: 'Cancel'
        };

        ngDialog.openConfirm({
            template: 'DeactivateModal',
            className: 'ngdialog-theme-plain',
            preCloseCallback: function (value) {
                var nestedConfirmDialog;

                nestedConfirmDialog = ngDialog.openConfirm({
                    template:
                        '<div style="width: 100%" align="center">' +
                        '<img src="ASSETS/img/logo_black_white.png" style="height: 45px;">' +
                        ' </div>' +
                        '<hr style="margin-top: -2px;">' +
                        '<p style="font-family: muli; color: #fff;"><b>Are you sure you want deactivate?</b></p>' +
                        '<div class="ngdialog-buttons">' +
                        '<button type="button" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-secondary" data-ng-click="closeThisDialog(0)">No' +
                        '<button type="button" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-primary" data-ng-click="confirm(1)">Yes' +
                        '</button></div>',
                    plain: true,
                    className: 'ngdialog-theme-plain custom-widththreefifty'
                });

                return nestedConfirmDialog;
            },
            scope: $scope,
            showClose: false
        })


            .then(function (value) {
                return false;
            }, function (value) {
                $scope.modal.last_day_work_new = new Date($scope.modal.last_day_works);
                $scope.modal.last_day_work = moment($scope.modal.last_day_work_new).format("YYYY-MM-DD");
                $scope.modal.effective_date_new = new Date($scope.modal.effective_dates);
                $scope.modal.effective_date = moment($scope.modal.effective_date_new).format("YYYY-MM-DD");
                $scope.modal["created_by"] = $scope.profile.pk;
                $scope.modal["supervisor_pk"] = $scope.profile.supervisor_pk;
                $scope.modal["pk"] = $scope.items[k].pk;
                $scope.modal["name"] = $scope.items[k].details.personal.first_name + " " + $scope.items[k].details.personal.middle_name + " " + $scope.items[k].details.personal.last_name;
                $scope.modal["date"] = date;
                var promise = EmployeesFactory.delete_employees($scope.modal);
                promise.then(function (data) {
                    $scope.archived = true;
                    ngDialog.openConfirm({
                        template: 'DeleteModal',
                        className: 'ngdialog-theme-plain custom-widththreesixtyhundred',
                        preCloseCallback: function (value) {
                        },
                        scope: $scope,
                        showClose: false
                    })
                        .then(function (value) {
                            return false;
                        }, function (value) {
                        });
                    employees();
                })
                    .then(null, function (data) {
                        ngDialog.openConfirm({
                            template: 'ErrorDeleteModal',
                            className: 'ngdialog-theme-plain custom-widththreesixtyhundred',
                            preCloseCallback: function (value) {
                            },
                            scope: $scope,
                            showClose: false
                        })
                            .then(function (value) {
                                return false;
                            }, function (value) {
                            });
                    });
            });
    }
    $scope.deler2 = function(v){
        $scope.modal = {
        title : 'Delete',
        message: '',
        save : 'Yes',
        close : 'No'
        };
        ngDialog.openConfirm({
        template: 'DeleteConfirm',
        className: 'ngdialog-theme-plain customdelete',
        scope: $scope,
        showClose: false
        })
        .then(function(value){
        return false;
        }, function(value){
        $scope.data = {
        policy_pk: v.pk,
        title: v.title,
        id :    v.id 
        };
        var promise = EmployeesFactory.delete_er2($scope.data);
        promise.then(function(data){
        ngDialog.openConfirm({
        template: 'DeleteModal',
        className: 'ngdialog-theme-plain customdelete',
        preCloseCallback: function(value) {
        },
        scope: $scope,
        showClose: false
        }).then(function(value){
        return false;
        }, function(value){
        });
        fetch_er2();
        })
        .then(null, function(data){
        ngDialog.openConfirm({
        template: 'ErrorEditModal',
        className: 'ngdialog-theme-plain custom-widththreesixtyhundred',
        preCloseCallback: function(value) {
        },
        scope: $scope,
        showClose: false
        }).then(function(value){
        return false;
        }, function(value){
        });
        });
        });
        }

    function get_work_days() {
        var promise = DefaultvaluesFactory.get_work_days();
        promise.then(function (data) {
            var a = data.data.result[0];
            var work_days = JSON.parse(a.details)
            for (var i in work_days) {
                if (work_days[i] == "true") {
                    work_days[i] = true;
                }
                else {
                    work_days[i] = false;
                }
            }
            $scope.work.monday = work_days.monday;
            $scope.work.tuesday = work_days.tuesday;
            $scope.work.wednesday = work_days.wednesday;
            $scope.work.thursday = work_days.thursday;
            $scope.work.friday = work_days.friday;
            $scope.work.saturday = work_days.saturday;
            $scope.work.sunday = work_days.sunday;
        })
            .then(null, function (data) {
            });
    }




    $scope.activate_employees = function (k) {
        $scope.modal = {
            title: '',
            message: 'Are you sure you want to reactivate this employee?',
            save: 'Reactivate',
            close: 'Cancel'
        };
        ngDialog.openConfirm({
            template: 'ConfirmModal',
            className: 'ngdialog-theme-plain',

            scope: $scope,
            showClose: false
        })
            .then(function (value) {
                return false;
            }, function (value) {
                var date = new Date();
                $scope.employees.data[k].date_today = date;
                $scope.employees.data[k].created_by = $scope.profile.pk;
                var promise = EmployeesFactory.activate_employees($scope.employees.data[k]);
                promise.then(function (data) {
                    $scope.archived = true;
                    ngDialog.openConfirm({
                        template: 'ActivateModal',
                        className: 'ngdialog-theme-plain custom-widththreesixtyhundred',
                        preCloseCallback: function (value) {
                        },
                        scope: $scope,
                        showClose: false
                    })
                        .then(function (value) {
                            return false;
                        }, function (value) {
                        });
                    employees();
                })
                    .then(null, function (data) {
                        ngDialog.openConfirm({
                            template: 'ErrorActivateModal',
                            className: 'ngdialog-theme-plain custom-widththreesixtyhundred',
                            preCloseCallback: function (value) {
                            },
                            scope: $scope,
                            showClose: false
                        })
                            .then(function (value) {
                                return false;
                            }, function (value) {
                            });
                    });
            });
    }

//John Dee
    function pushElement()
    {
        $scope.notEmpty.firstname = $scope.employee.first_name;
        $scope.notEmpty.middle_name = $scope.employee.middle_name;
        $scope.notEmpty.last_name = $scope.employee.last_name;
        $scope.notEmpty.email_address = $scope.employee.email_address;
        $scope.notEmpty.gender = $scope.employee.gender;
        $scope.notEmpty.religion = $scope.employee.religion;
        $scope.notEmpty.civilstatus = $scope.employee.civilstatus;
        $scope.notEmpty.employee_id = $scope.employee.employee_id;
        $scope.notEmpty.date_started = $scope.employee.date_started;
        $scope.notEmpty.business_email_address = $scope.employee.business_email_address;
        $scope.notEmpty.birth_date = $scope.employee.birth_date;
        $scope.notEmpty.titles_pk = $scope.employee.titless;
        $scope.notEmpty.levels_pk = $scope.employee.levels_pk;
        $scope.notEmpty.teams_pk = $scope.employee.teams_pk;
        $scope.notEmpty.supervisor_pk = $scope.employee.supervisor_pk;
        $scope.notEmpty.departments_pk = $scope.employee.departments_pk;
        $scope.notEmpty.employee_status = $scope.employee.employee_status;
        $scope.notEmpty.employment_type = $scope.employee.employment_types;
        $scope.notEmpty.permanent_address = $scope.employee.permanent_address;
        $scope.notEmpty.present_address = $scope.employee.present_address;
        $scope.notEmpty.company_name = $scope.employee.company_name;
        $scope.notEmpty.emergency_contact_number = $scope.employee.emergency_contact_number;
        $scope.notEmpty.emergency_name = $scope.employee.emergency_contact_name;
        $scope.notEmpty.emergency_relationship = $scope.employee.emergency_relationship;
    }

    $scope.edit_employees = function (k) 
    {
        get_supervisors();
        if ($scope.profile.permission.compensation != null) {
            $scope.compensation_status = true;
            $scope.compensation.group10 = $scope.items[k].details.company.groupings;
            if ($scope.items[k].details.company.groupings == "Rank & File") {
                if ($scope.profile.permission.compensation.rank == '1') {
                    $scope.compensation.group1 = "Rank & File";
                } else {
                    $scope.compensation_status = false;
                }
            }
            if ($scope.items[k].details.company.groupings == "Supervisor") {
                if ($scope.profile.permission.compensation.supervisor == '1') {
                    $scope.compensation.group2 = "Supervisor";
                } else {
                    $scope.compensation_status = false;
                }
            }
            if ($scope.items[k].details.company.groupings == "Managerial") {
                if ($scope.profile.permission.compensation.manager == '1') {
                    $scope.compensation.group3 = "Managerial";
                } else {
                    $scope.compensation_status = false;
                }
            }
            if ($scope.items[k].details.company.groupings == "Executive") {
                if ($scope.profile.permission.compensation.executive == '1') {
                    $scope.compensation.group4 = "Executive";
                } else {
                    $scope.compensation_status = false;
                }
            }
            if ($scope.items[k].details.company.groupings == "Specialist") {
                if ($scope.profile.permission.compensation.specialist == '1') {
                    $scope.compensation.group5 = "Specialist";
                } else {
                    $scope.compensation_status = false;
                }
            }
            if ($scope.items[k].details.company.groupings == "C-Level") {
                if ($scope.profile.permission.compensation.clevel == '1') {
                    $scope.compensation.group6 = "C-Level";
                } else {
                    $scope.compensation_status = false;
                }
            }
            $scope.compensation.pk = $scope.items[k].pk;
            var promise = EmployeesFactory.get_by_level($scope.compensation);
            promise.then(function (data) {
                $scope.disp_employees = data.data.result[0];
                $scope.disp_employees.details = JSON.parse($scope.disp_employees.details);
                //Company -> Salary - > Salary Amount Validator

                if ($scope.disp_employees.details != undefined) {
                    if ($scope.disp_employees.details.company.salary.details !== undefined) {

                        if ($scope.disp_employees.details.company.salary.details.amount === undefined) {
                            $scope.employee.amount = null;
                        }
                        else if ($scope.disp_employees.details.company.salary.details.amount !== undefined) {
                            $scope.employee.amount = $scope.disp_employees.details.company.salary.details.amount;
                        }
                        if ($scope.disp_employees.details.company.salary.details.weekly_amount === undefined) {
                            $scope.employee.weekly_amount = null;
                        }
                        else if ($scope.disp_employees.details.company.salary.details.weekly_amount !== undefined) {
                            $scope.employee.weekly_amount = $scope.disp_employees.details.company.salary.details.weekly_amount;
                        }
                        if ($scope.disp_employees.details.company.salary.details.monthly_amount === undefined) {
                            $scope.employee.monthly_amount = null;
                        }
                        else if ($scope.disp_employees.details.company.salary.details.monthly_amount !== undefined) {
                            $scope.employee.monthly_amount = $scope.disp_employees.details.company.salary.details.monthly_amount;
                        }
                        if ($scope.disp_employees.details.company.salary.details.hourly_amount === undefined) {
                            $scope.employee.hourly_amount = null;
                        }
                        else if ($scope.disp_employees.details.company.salary.details.hourly_amount !== undefined) {
                            $scope.employee.hourly_amount = $scope.disp_employees.details.company.salary.details.hourly_amount;
                        }
                        if ($scope.disp_employees.details.company.salary.details.mnontax_allowance === undefined) {
                            $scope.employee.mnontax_allowance = null;
                        }
                        else if ($scope.disp_employees.details.company.salary.details.mnontax_allowance !== undefined) {
                            $scope.employee.mnontax_allowance = $scope.disp_employees.details.company.salary.details.mnontax_allowance;
                        }
                        if ($scope.disp_employees.details.company.salary.details.wnontax_allowance === undefined) {
                            $scope.employee.wnontax_allowance = null;
                        }
                        else if ($scope.disp_employees.details.company.salary.details.wnontax_allowance !== undefined) {
                            $scope.employee.wnontax_allowance = $scope.disp_employees.details.company.salary.details.wnontax_allowance;
                        }
                        if ($scope.disp_employees.details.company.salary.details.dnontax_allowance === undefined) {
                            $scope.employee.dnontax_allowance = null;
                        }
                        else if ($scope.disp_employees.details.company.salary.details.dnontax_allowance !== undefined) {
                            $scope.employee.dnontax_allowance = $scope.disp_employees.details.company.salary.details.dnontax_allowance;
                        }
                        if ($scope.disp_employees.details.company.salary.details.hnontax_allowance === undefined) {
                            $scope.employee.hnontax_allowance = null;
                        }
                        else if ($scope.disp_employees.details.company.salary.details.hnontax_allowance !== undefined) {
                            $scope.employee.hnontax_allowance = $scope.disp_employees.details.company.salary.details.hnontax_allowance;
                        }
                    }
                } else {

                }
            }).then(null, function (data) {
                $scope.compensation_status = false;
            });
        } else {
            $timeout(function () {
                $scope.compensation_status = false;
                ngDialog.openConfirm({
                    template: 'CompensationDetectorModal',
                    className: 'ngdialog-theme-plain custom-widththreesixtyhundred1',
                    scope: $scope,
                    showClose: false
                });
            }, 1500);
        }
        $scope.employee = $scope.items[k];
        $scope.employee.company_name = $scope.employees.data[k].company_name;
    
        if ($scope.items[k].details.company === undefined) {
            $scope.items[k].details.company = null;
        }
        else if ($scope.items[k].details.company != null) {

            if ($scope.items[k].details.company.salary === undefined) {
                $scope.items[k].details.company.salary = null;
                $scope.employee.salary_type = '4';
            }
            else if ($scope.items[k].details.company.salary != null) {

                if ($scope.items[k].details.company.salary.salary_type === undefined || $scope.items[k].details.company.salary.salary_type == 'null') {
                    $scope.employee.salary_type = '4';
                }
                else if ($scope.items[k].details.company.salary.salary_type !== undefined) {
                    $scope.employee.salary_type = $scope.items[k].details.company.salary.salary_type;
                }

                if ($scope.items[k].details.company.salary.pay_periods_pk === undefined) {
                    $scope.employee.pay_period = '';
                }
                else if ($scope.items[k].details.company.salary.pay_periods_pk !== undefined) {
                    $scope.employee.pay_period = $scope.items[k].details.company.salary.pay_periods_pk;
                }

                if ($scope.items[k].details.company.salary.rate_types_pk === undefined) {
                    $scope.employee.rate_type = '';
                }
                else if ($scope.items[k].details.company.salary.rate_types_pk !== undefined) {
                    $scope.employee.rate_type = $scope.items[k].details.company.salary.rate_types_pk;
                }
                if ($scope.items[k].details.company.salary.details === undefined) {
                    $scope.items[k].details.company.salary.details == null;
                }
                else if ($scope.items[k].details.company.salary.details != null) {


                    if ($scope.items[k].details.company.salary.details.bank_name === undefined) {
                        $scope.items[k].details.company.salary.details.bank_name = null;
                    }
                    else if ($scope.items[k].details.company.salary.details.bank_name !== undefined) {
                        $scope.employee.bank_name = $scope.items[k].details.company.salary.details.bank_name;
                    }

                    if ($scope.items[k].details.company.salary.details.account_number === undefined) {
                        $scope.items[k].details.company.salary.details.account_number = null;
                    }
                    else if ($scope.items[k].details.company.salary.details.account_number !== undefined) {
                        $scope.employee.account_number = $scope.items[k].details.company.salary.details.account_number;
                    }

                    if ($scope.items[k].details.company.salary.details.mode_payment === undefined) {
                        $scope.items[k].details.company.salary.details.mode_payment = null;
                    }
                    else if ($scope.items[k].details.company.salary.details.mode_payment !== undefined) {
                        $scope.employee.salary_mode_payment = $scope.items[k].details.company.salary.details.mode_payment;
                    }


                    if ($scope.items[k].details.company.salary.dependents_status === undefined || $scope.items[k].details.company.salary.dependents_status == null) {
                        $scope.employee.dependents_status = false;
                    }
                    else if ($scope.items[k].details.company.salary.dependents_status != null) {
                        if ($scope.items[k].details.company.salary.dependents_status == 'true') {
                            $scope.employee.dependents_status = true;
                        }
                        else {
                            $scope.employee.dependents_status = false;
                        }
                    }

                    if ($scope.items[k].details.company.salary.details.loan_status === undefined || $scope.items[k].details.company.salary.details.loan_status == null) {
                        $scope.employee.loan_status = false;
                    }
                    else if ($scope.items[k].details.company.salary.details.loan_status != null) {
                        if ($scope.items[k].details.company.salary.details.loan_status == 'true') {
                            $scope.employee.loan_status = true;
                        }
                        else {
                            $scope.employee.loan_status = false;
                        }
                    }

                    if ($scope.items[k].details.company.salary.details.leave_status === undefined || $scope.items[k].details.company.salary.details.leave_status == null) {
                        $scope.employee.leave_status = false;
                    }
                    else if ($scope.items[k].details.company.salary.details.leave_status != null) {
                        if ($scope.items[k].details.company.salary.details.leave_status == 'true') {
                            $scope.employee.leave_status = true;
                        }
                        else {
                            $scope.employee.leave_status = false;
                        }
                    }


                    if ($scope.items[k].details.company.salary.upload_documents === undefined || $scope.items[k].details.company.salary.upload_documents == null) {
                        $scope.employee.upload_documents = false;
                    }
                    else if ($scope.items[k].details.company.salary.upload_documents != null) {
                        if ($scope.items[k].details.company.salary.upload_documents == true) {
                            $scope.employee.upload_documents = true;
                        }
                        else{
                            $scope.employee.upload_documents = false;
                        }
                    }


                    if ($scope.items[k].details.company.salary.details.allowances === undefined) {
                        $scope.items[k].details.company.salary.details.allowances = null;
                        $scope.employee.allowances = [];
                    }
                    else if ($scope.items[k].details.company.salary.details.allowances !== undefined) {
                        $scope.employee.allowances = $scope.items[k].details.company.salary.details.allowances;
                    }

                    if ($scope.items[k].details.company.salary.details.loans === undefined) {
                        $scope.items[k].details.company.salary.details.loans = null;
                        $scope.employee.loans = [];
                    }
                    else if ($scope.items[k].details.company.salary.details.loans !== undefined) {
                        $scope.employee.loans = $scope.items[k].details.company.salary.details.loans;
                    }

                    if ($scope.items[k].details.company.salary.details.leaves_pm === undefined) {
                        $scope.items[k].details.company.salary.details.leaves_pm = null;
                        $scope.employee.leaves_pm = [];
                    }
                    else if ($scope.items[k].details.company.salary.details.leaves_pm !== undefined) {
                        $scope.employee.leaves_pm = $scope.items[k].details.company.salary.details.leaves_pm;
                    }

                    if ($scope.items[k].details.company.salary.details.documents === undefined) {
                        $scope.items[k].details.company.salary.details.documents = null;
                        $scope.employee.documents=[];
                    }
                    else if ($scope.items[k].details.company.salary.details.documents !== undefined) {
                        $scope.employee.documents = $scope.items[k].details.company.salary.details.documents;
}


                    if ($scope.items[k].details.company.salary.details.dependents === undefined) {
                        $scope.items[k].details.company.salary.details.dependents = null;
                        $scope.employee.dependents = [];
                    }
                    else if ($scope.items[k].details.company.salary.details.dependents !== undefined) {
                        $scope.employee.dependents = $scope.items[k].details.company.salary.details.dependents;
                    }

                    if ($scope.items[k].details.company.salary.allowances_status === undefined || $scope.items[k].details.company.salary.allowances_status == null) {
                        $scope.employee.allowances_status = false;
                    }
                    else if ($scope.items[k].details.company.salary.allowances_status != null) {
                        if ($scope.items[k].details.company.salary.allowances_status == 'true') {
                            $scope.employee.allowances_status = true;
                        }
                        else {
                            $scope.employee.allowances_status = false;
                        }
                    }
                }
            }

            if ($scope.items[k].details.company.hours === undefined || $scope.items[k].details.company.hours == null) {
                $scope.items[k].details.company.hours = null;
            }
            else if ($scope.items[k].details.company.hours != null) {
                $scope.employee.intern_hours = $scope.items[k].details.company.hours;
            }

            // if ($scope.items[k].details.company.company_name === undefined || $scope.items[k].details.company.company_name == null) {
            //     $scope.items[k].details.company.company_name = null;
            // }
            // else if ($scope.items[k].details.company.company_name != null) {
            //     $scope.employee.company_name = $scope.items[k].details.company.company_name;
            // }

            if ($scope.items[k].details.company.employee_id === undefined || $scope.items[k].details.company.employee_id == null) {
                $scope.employee.employee_id = '';
            }
            else if ($scope.items[k].details.company.employee_id != null) {
                $scope.employee.employee_id = $scope.items[k].details.company.employee_id;
            }

            if ($scope.items[k].details.company.old_id === undefined || $scope.items[k].details.company.old_id == null) {
                $scope.employee.old_id = '';
            }
            else if ($scope.items[k].details.company.old_id != null) {
                $scope.employee.old_id = $scope.items[k].details.company.old_id;
            }

            if ($scope.items[k].details.company.business_email_address === undefined || $scope.items[k].details.company.business_email_address == null) {
                $scope.employee.business_email_address = '';
            }
            else if ($scope.items[k].details.company.business_email_address != null) {
                $scope.employee.business_email_address = $scope.items[k].details.company.business_email_address;
            }

            if ($scope.items[k].details.company.departments_pk === undefined || $scope.items[k].details.company.departments_pk == null) {
                $scope.employee.departments_pk = '';
            }
            else if ($scope.items[k].details.company.departments_pk != null) {
                $scope.employee.departments_pk = $scope.items[k].details.company.departments_pk;
            }

            if ($scope.items[k].details.company.levels_pk === undefined || $scope.items[k].details.company.levels_pk == null) {
                $scope.employee.levels_pk = '';
            }
            else if ($scope.items[k].details.company.levels_pk != null) {
                $scope.employee.levels_pk = $scope.items[k].details.company.levels_pk;
            }

            if ($scope.items[k].details.company.titles_pk === undefined || $scope.items[k].details.company.titles_pk == null) {
                $scope.employee.titless = '';
            }
            else if ($scope.items[k].details.company.titles_pk != null) {
                $scope.employee.titless = $scope.items[k].details.company.titles_pk;
                $scope.employee.groupings = $scope.items[k].groupings;
            }

            if ($scope.items[k].details.company.branch === undefined || $scope.items[k].details.company.branch == null) {
                $scope.employee.branch = '';



            }
            else if ($scope.items[k].details.company.branch != null) {
                $scope.employee.branch = $scope.items[k].details.company.branch;
                $scope.employee.branch = $scope.items[k].branch;
            }

            if ($scope.items[k].details.company.subcompany === undefined || $scope.items[k].details.company.subcompany == null) {
                $scope.employee.subcompany = '';
            }
            else if ($scope.items[k].details.company.subcompany != null) {
                $scope.employee.subcompany = $scope.items[k].details.company.subcompany;
                $scope.employee.subcompany = $scope.items[k].subcompany;
            }


            if ($scope.items[k].details.company.benefit_suspension === undefined || $scope.items[k].details.company.benefit_suspension == null) {
                $scope.employee.benefit_suspension = undefined;
            } else if ($scope.items[k].details.company.benefit_suspension != null) {
                if ($scope.items[k].details.company.benefit_suspension == "true") {
                    $scope.employee.benefit_suspension = true;
                }
            }


            if ($scope.items[k].details.company.supervisor_pk === undefined || $scope.items[k].details.company.supervisor_pk == null) {
                $scope.employee.supervisor_pk = '';
            }
            else if ($scope.items[k].details.company.supervisor_pk != null) {
                $scope.employee.supervisor_pk = $scope.items[k].details.company.supervisor_pk;
            }

            if ($scope.items[k].details.company.employee_status_pk === undefined || $scope.items[k].details.company.employee_status_pk == null) {
                $scope.employee.employee_status = '';
            }
            else if ($scope.items[k].details.company.employee_status_pk != null) {
                $scope.employee.employee_status = $scope.items[k].details.company.employee_status_pk;
            }

            if ($scope.items[k].details.company.work_status === undefined || $scope.items[k].details.company.work_status == null) {
                $scope.employee.work_status = false;
            }
            else if ($scope.items[k].details.company.work_status != null) {
                if ($scope.items[k].details.company.work_status == 'true') {
                    $scope.employee.work_status = true;
                }
                else {
                    $scope.employee.work_status = false;
                }

            }

            if ($scope.items[k].details.company.train_seminar === undefined || $scope.items[k].details.company.train_seminar == null) {
                $scope.employee.train_seminar = false;
            }
            else if ($scope.items[k].details.company.train_seminar != null) {
                if ($scope.items[k].details.company.train_seminar == 'true') {
                    $scope.employee.train_seminar = true;
                }
                else {
                    $scope.employee.train_seminar = false;
                }
            }


            if ($scope.items[k].details.company.employment_type_pk === undefined || $scope.items[k].details.company.employment_type_pk == null) {
                $scope.employee.employment_types = '';
            }
            else if ($scope.items[k].details.company.employment_type_pk != null) {
                $scope.employee.employment_types = $scope.items[k].details.company.employment_type_pk;
            }

            if ($scope.items[k].details.company.date_started === undefined || $scope.items[k].details.company.date_started == null) {
                $scope.employee.date_started = 'No Data';
            }
            else if ($scope.items[k].details.company.date_started != null) {
                $scope.employee.date_started = new Date($scope.items[k].details.company.date_started);
            }


            if ($scope.items[k].details.company.contract_status === undefined || $scope.items[k].details.company.contract_status == null) {
                $scope.employee.contract_yes = false;
                $scope.employee.contract_no = false;
            }
            else if ($scope.items[k].details.company.contract_status != null) {
                if ($scope.items[k].details.company.contract_status == 'true') {
                    $scope.employee.contract_yes = 1;
                }
                else if ($scope.items[k].details.company.contract_status == 'false') {
                    $scope.employee.contract_yes = 2;
                }
                else {
                    $scope.employee.contract_yes = false;
                    $scope.employee.contract_no = false;
                }
            }


            if ($scope.items[k].details.company.regularization_date === undefined || $scope.items[k].details.company.regularization_date == null) {
                $scope.employee.regularization_date = undefined;
            }
            else if ($scope.items[k].details.company.regularization_date != null) {
                $scope.employee.regularization_date = new Date($scope.items[k].details.company.regularization_date);
            }

            if ($scope.items[k].details.company.training_seminars === undefined || $scope.items[k].details.company.training_seminars == null) {
                $scope.employee.seminar_trainings = [{ type: "Training" }];
            }
            else if ($scope.items[k].details.company.training_seminars != null || $scope.items[k].details.company.training_seminars !== undefined) {
                $scope.employee.seminar_trainings = $scope.items[k].details.company.training_seminars;
            }
            if ($scope.items[k].details.company.work_experience === undefined || $scope.items[k].details.company.work_experience == null) {
                $scope.employee.work_experience = [{ type: "First" }];
            }
            else if ($scope.items[k].details.company.work_experience != null || $scope.items[k].details.company.work_experience !== undefined) {
                $scope.employee.work_experience = $scope.items[k].details.company.work_experience;
            }

            if ($scope.items[k].details.company.work_schedule == undefined || $scope.items[k].details.company.work_schedule == null) {
                $scope.employee.work_days = 0;
            }
            else if ($scope.items[k].details.company.work_schedule != null || $scope.items[k].details.company.work_schedule !== undefined) {
                $scope.employee.work_schedule = $scope.items[k].details.company.work_schedule;
                if($scope.employee.work_schedule.work_days_status != undefined){
                    if($scope.employee.work_schedule.work_days_status == '[object Object]' || $scope.employee.work_schedule.work_days_status == '' || $scope.employee.work_schedule.work_days_status == null){
                        $scope.employee.work_schedule.work_days_status = [];
                    }else{
                        $scope.employee.work_days_status = JSON.parse($scope.employee.work_schedule.work_days_status);
                    }
                }
                $scope.employee.work_days = $scope.employee.work_schedule.work_days;
            }
        }

        if ($scope.items[k].details.personal === undefined) {
            $scope.items[k].details.personal = null;
            $scope.employee.first_name = '';
            $scope.employee.middle_name = '';
            $scope.employee.last_name = '';
            $scope.employee.contact_number = '';
            $scope.employee.landline_number = '';
            $scope.employee.present_address = '';
            $scope.employee.permanent_address = '';
            $scope.employee.profile_picture = './ASSETS/img/blank.gif';
            $scope.employee.email_address = '';
            $scope.employee.gender = '';
            $scope.employee.religion = '';
            $scope.employee.civilstatus = '';
            $scope.employee.birth_date = '';
            $scope.employee.emergency_contact_name = '';
            $scope.employee.emergency_contact_number = '';
        }

        else if ($scope.items[k].details.personal != null) {

            if ($scope.items[k].details.personal.first_name === undefined || $scope.items[k].details.personal.first_name == null) {
                $scope.employee.first_name = '';
            }
            else if ($scope.items[k].details.personal.first_name != null || $scope.items[k].details.personal.first_name !== undefined) {
                $scope.employee.first_name = $scope.items[k].details.personal.first_name;
            }

            if ($scope.items[k].details.personal.middle_name === undefined || $scope.items[k].details.personal.middle_name == null) {
                $scope.employee.middle_name = '';
            }
            else if ($scope.items[k].details.personal.middle_name != null || $scope.items[k].details.personal.middle_name !== undefined) {
                $scope.employee.middle_name = $scope.items[k].details.personal.middle_name;
            }

            if ($scope.items[k].details.personal.last_name === undefined || $scope.items[k].details.personal.last_name == null) {
                $scope.employee.last_name = '';
            }
            else if ($scope.items[k].details.personal.last_name != null || $scope.items[k].details.personal.last_name !== undefined) {
                $scope.employee.last_name = $scope.items[k].details.personal.last_name;
            }

            if ($scope.items[k].details.personal.contact_number === undefined || $scope.items[k].details.personal.contact_number == null) {
                $scope.employee.contact_number = '';
            }
            else if ($scope.items[k].details.personal.contact_number != null || $scope.items[k].details.personal.contact_number !== undefined) {
                $scope.employee.contact_number = $scope.items[k].details.personal.contact_number;
            }

            if ($scope.items[k].details.personal.landline_number === undefined || $scope.items[k].details.personal.landline_number == null) {
                $scope.employee.landline_number = '';
            }
            else if ($scope.items[k].details.personal.landline_number != null || $scope.items[k].details.personal.landline_number !== undefined) {
                $scope.employee.landline_number = $scope.items[k].details.personal.landline_numberlandline_number;
            }

            if ($scope.items[k].details.personal.present_address === undefined || $scope.items[k].details.personal.present_address == null) {
                $scope.employee.present_address = '';
            }
            else if ($scope.items[k].details.personal.present_address != null || $scope.items[k].details.personal.present_address !== undefined) {
                $scope.employee.present_address = $scope.items[k].details.personal.present_address;
            }

            if ($scope.items[k].details.personal.permanent_address === undefined || $scope.items[k].details.personal.permanent_address == null) {
                $scope.employee.permanent_address = '';
            }
            else if ($scope.items[k].details.personal.permanent_address != null || $scope.items[k].details.personal.permanent_address !== undefined) {
                $scope.employee.permanent_address = $scope.items[k].details.personal.permanent_address;
            }

            if ($scope.items[k].details.personal.profile_picture === undefined || $scope.items[k].details.personal.profile_picture == null) {
                $scope.employee.profile_picture = './ASSETS/img/blank.gif';
            }
            else if ($scope.items[k].details.personal.profile_picture != null || $scope.items[k].details.personal.profile_picture !== undefined) {
                $scope.employee.profile_picture = $scope.items[k].details.personal.profile_picture;
            }

            if ($scope.items[k].details.personal.email_address === undefined || $scope.items[k].details.personal.email_address == null) {
                $scope.employee.email_address = '';
            }
            else if ($scope.items[k].details.personal.email_address != null || $scope.items[k].details.personal.email_address !== undefined) {
                $scope.employee.email_address = $scope.items[k].details.personal.email_address;
            }

            if ($scope.items[k].details.personal.gender === undefined || $scope.items[k].details.personal.gender == null) {
                $scope.employee.gender = '';
            }
            else if ($scope.items[k].details.personal.gender != null || $scope.items[k].details.personal.gender !== undefined) {
                $scope.employee.gender = $scope.items[k].details.personal.gender;
            }

            if ($scope.items[k].details.personal.religion === undefined || $scope.items[k].details.personal.religion == null) {
                $scope.employee.religion = '';
            }
            else if ($scope.items[k].details.personal.religion != null || $scope.items[k].details.personal.religion !== undefined) {
                $scope.employee.religion = $scope.items[k].details.personal.religion;
            }

            if ($scope.items[k].details.personal.civilstatus === undefined || $scope.items[k].details.personal.civilstatus == null) {
                $scope.employee.civilstatus = '';
            }
            else if ($scope.items[k].details.personal.civilstatus != null || $scope.items[k].details.personal.civilstatus !== undefined) {
                $scope.employee.civilstatus = $scope.items[k].details.personal.civilstatus;
            }

            if ($scope.items[k].details.personal.spouse === undefined || $scope.items[k].details.personal.spouse == null) {
                $scope.employee.spouse = '';
            }
            else if ($scope.items[k].details.personal.spouse != null || $scope.items[k].details.personal.spouse !== undefined) {
                $scope.employee.spouse = $scope.items[k].details.personal.spouse;
            }

            if ($scope.items[k].details.personal.birth_date === undefined || $scope.items[k].details.personal.birth_date == null) {
                $scope.employee.birth_date = '';
            }
            else if ($scope.items[k].details.personal.birth_date != null || $scope.items[k].details.personal.birth_date !== undefined) {
                $scope.employee.birth_date = new Date($scope.items[k].details.personal.birth_date);
            }

            if ($scope.items[k].details.personal.emergency_contact_name === undefined || $scope.items[k].details.personal.emergency_contact_name == null) {
                $scope.employee.emergency_contact_name = '';
            }
            else if ($scope.items[k].details.personal.emergency_contact_name != null || $scope.items[k].details.personal.emergency_contact_name !== undefined) {
                $scope.employee.emergency_contact_name = $scope.items[k].details.personal.emergency_contact_name;
            }

            if ($scope.items[k].details.personal.emergency_contact_number === undefined || $scope.items[k].details.personal.emergency_contact_number == null) {
                $scope.employee.emergency_contact_number = '';
            }
            else if ($scope.items[k].details.personal.emergency_contact_number != null || $scope.items[k].details.personal.emergency_contact_number !== undefined) {
                $scope.employee.emergency_contact_number = $scope.items[k].details.personal.emergency_contact_number;
            }

            if ($scope.items[k].details.personal.emergency_relationship === undefined || $scope.items[k].details.personal.emergency_relationship == null) {
                $scope.employee.emergency_relationship = '';
            }
            else if ($scope.items[k].details.personal.emergency_relationship != null || $scope.items[k].details.personal.emergency_relationship !== undefined) {
                $scope.employee.emergency_relationship = $scope.items[k].details.personal.emergency_relationship;
            }

            if ($scope.items[k].details.personal.hobbies === undefined || $scope.items[k].details.personal.hobbies == null) {
                $scope.employee.hobbies = '';
            }
            else if ($scope.items[k].details.personal.hobbies != null || $scope.items[k].details.personal.hobbies !== undefined) {
                $scope.employee.hobbies = $scope.items[k].details.personal.hobbies;
            }

            if ($scope.items[k].details.personal.interest === undefined || $scope.items[k].details.personal.interest == null) {
                $scope.employee.interest = '';
            }
            else if ($scope.items[k].details.personal.interest != null || $scope.items[k].details.personal.interest !== undefined) {
                $scope.employee.interest = $scope.items[k].details.personal.interest;
            }

            if ($scope.items[k].details.personal.extra_curricular === undefined || $scope.items[k].details.personal.extra_curricular == null) {
                $scope.employee.extra_curricular = '';
            }
            else if ($scope.items[k].details.personal.extra_curricular != null || $scope.items[k].details.personal.extra_curricular !== undefined) {
                $scope.employee.extra_curricular = $scope.items[k].details.personal.extra_curricular;
            }

            if ($scope.items[k].details.personal.achievements === undefined || $scope.items[k].details.personal.achievements == null) {
                $scope.employee.achievements = '';
            }
            else if ($scope.items[k].details.personal.achievements != null || $scope.items[k].details.personal.achievements !== undefined) {
                $scope.employee.achievements = $scope.items[k].details.personal.achievements;
            }

            if ($scope.items[k].details.personal.sports === undefined || $scope.items[k].details.personal.sports == null) {
                $scope.employee.sports = '';
            }
            else if ($scope.items[k].details.personal.sports != null || $scope.items[k].details.personal.sports !== undefined) {
                $scope.employee.sports = $scope.items[k].details.personal.sports;
            }
        }

        $scope.employee.hremployee=$scope.items[k].details.company.hremployee;

        for(var g in $scope.hremployee){
            $scope.hremployee[g].ticked = false;
            for(var i in $scope.employee.hremployee){
                if($scope.employee.hremployee[i].pk==$scope.hremployee[g].pk)
                    $scope.hremployee[g].ticked = true;
            }
        }
        // console.log($scope.hremployee);
        $scope.employee.emaildatereminder1 = new Date($scope.items[k].details.company.emaildatereminder1);
        $scope.employee.emaildatereminder2 = new Date($scope.items[k].details.company.emaildatereminder2);
        if ($scope.items[k].details.education === undefined) {
            $scope.items[k].details.education = null;
            $scope.employee.educations = [{ educ_level: "Primary" }];
        }
        else if ($scope.items[k].details.education != null) {
            if ($scope.items[k].details.education.school_type === undefined || $scope.items[k].details.education.school_type == null) {
                $scope.employee.educations = [{ educ_level: "Primary" }];
            }
            else if ($scope.items[k].details.education.school_type != null || $scope.items[k].details.education.school_type !== undefined) {
                $scope.employee.education = $scope.items[k].details.education.school_type;
                $scope.employee.educations = $scope.employee.education;
            }
        }

//John Dee
        if ($scope.items[k].details.government === undefined)
        {
            $scope.items[k].details.government = null;
            $scope.employee.government = [{ idType: "" }];
        }
        else if ($scope.items[k].details.government != null) 
        {
            if ($scope.items[k].details.government.idType === undefined || $scope.items[k].details.government.idType == null) 
            {
                $scope.employee.government = [{ idType: "" }];
            }
            else if ($scope.items[k].details.government.idType != null || $scope.items[k].details.government.idType !== undefined) 
            {
                $scope.employee.government = $scope.items[k].details.government.idType;
            }

            if($scope.items[k].details.government.data_pagmid != undefined){
                $scope.employee.government.push({idType: 'PAGIBIG',idNumber:$scope.items[k].details.government.data_pagmid});
            }
            if($scope.items[k].details.government.data_sss != undefined){
                $scope.employee.government.push({idType: 'SSS',idNumber:$scope.items[k].details.government.data_sss});
            }
            if($scope.items[k].details.government.data_tin != undefined){
                $scope.employee.government.push({idType: 'TIN',idNumber:$scope.items[k].details.government.data_tin});
            }
            if($scope.items[k].details.government.data_phid != undefined){
                $scope.employee.government.push({idType: 'PHILHEALTH',idNumber:$scope.items[k].details.government.data_phid});
            }
        }

        if ($scope.employee.salary_type != null || $scope.employee.salary_type != undefined) {
            $scope.isShown = function (salarys_type) {
                return salarys_type === $scope.employee.salary_type;
            };
        }

//John Dee
        $scope.addIdType = function () 
        {
           $scope.employee.government.push({ idType: $scope.id.idType});
        };
        $scope.removeId = function (z)
        {
            $scope.employee.government.splice(z, 1);
        };

        $scope.addNewChoice = function () {
           $scope.employee.educations.push({ educ_level: $scope.employee.school_type });
        };
        $scope.addNewChoice1 = function () {
            if ($scope.employee.seminar == '2') {
                $scope.employee.seminar_trainings.push({ type: "Training" });
            }
            else if ($scope.employee.seminar == '1') {
                $scope.employee.seminar_trainings.push({ type: "Seminar" });
            }
        };
    
        $scope.addNewChoice2 = function () {
            if ($scope.employee.work_experience.length == 3) {
                alert("Maximum 3 Working Experience Only");
            }
            else if ($scope.employee.work_experience.length == 0) {
                $scope.employee.work_experience.push({ type: "First" });
            }
            else if ($scope.employee.work_experience.length == 1) {
                $scope.employee.work_experience.push({ type: "Second" });
            }
            else if ($scope.employee.work_experience.length == 2) {
                $scope.employee.work_experience.push({ type: "Third" });
            }
        };
        if ($scope.employee.allowances == null || $scope.employee.allowances == '') {
            $scope.employee.allowances = [];
        }
        $scope.add_allowances = function () {
            $scope.employee.allowances.push({
                allowance_types: this.allowance_types,
                allowance_amount: this.allowance_amount
            });
        };
        $scope.add_loan = function () {
            $scope.employee.loans.push({
                loan_type: this.loan_type,
                loan_amount: this.loan_amount,
                loan_date_issued: moment(this.loan_date_issued).format("MM-DD-YYYY"),
                loan_start_in_month: this.loan_start_in_month,
                loan_start_in_year: this.loan_start_in_year,
                loan_amortization: this.amortization,
                payout_type: this.payout_type
            });
        };
        $scope.add_leave = function () {
            this.employee.leaves_pm.push({
                leave_type: this.leave_type,
                leave_amount: this.leave_amount
            });
        };

        $scope.add_dependent = function () {
            $scope.employee.dependents.push({
                dependent_full_name: this.dependent_full_name,
                dependent_birth_date: this.dependent_birth_date,
                dependent_relationship: this.dependent_relationship,
                dependent_supporting_document: this.dependent_upload
            });
        };

        $scope.del_allowances = function (ind) {
            this.employee.allowances.splice(ind, 1);
        };

        $scope.del_loans = function (ind) {
            this.employee.loans.splice(ind, 1);
        };

        $scope.del_leave = function (ind) {
            this.employee.leaves_pm.splice(ind, 1);
        };

        $scope.del_dependent = function (ind) {
            this.employee.dependents.splice(ind, 1);
        };
        
        $scope.removeChoice = function (z) {

            $scope.employee.educations.splice(z, 1);
        };
        $scope.removeChoice1 = function (z) {

            $scope.employee.seminar_trainings.splice(z, 1);
        };

        $scope.removeChoice2 = function (z) {

            $scope.employee.work_experience.splice(z, 1);
        };

        $scope.isShown = function (salarys_type) {
            return salarys_type === $scope.employee.salary_type;
        };

        level_changed();
        $scope.modal = {

            title: 'Edit ' + $scope.items[k].details.personal.first_name,
            save: 'Apply Changes',
            close: 'Cancel',
            showClose: false
        };

        ngDialog.openConfirm({
            template: 'EditModal',
            className: 'ngdialog-theme-plain custom-lista',
            preCloseCallback: function (value) {
                $scope.modal_remarks = 
                {
                    title: 'Reason for Editing',
                    remarks: ''
                }

//Check if all the element is not empty
                pushElement();
                var count = 0;
                // var val = Object.values($scope.notEmpty);
                for (var i in $scope.notEmpty)
                    //var i = 0; i < val.length; i++)
                {
                    if(i == "" || i == undefined || i == null)
                        count++;

                    // if (val[i] == "" || val[i] == undefined || val == null)
                    // {
                    //      count++;
                    // }

                }
                
                if (count > 0)
                {
                    ngDialog.openConfirm({
                        template: 'EmailModal',
                        className: 'ngdialog-theme-plain custom-widththreesixtyhundred',
                        scope: $scope,
                        showClose: false
                    });
                    return false;
                }

                var nestedConfirmDialog;
                nestedConfirmDialog = ngDialog.openConfirm({
                    template: 'ApplyModal',
                    className: 'ngdialog-theme-plain custom-applymodal',
                    scope: $scope,
                    showClose: false
                });
                return nestedConfirmDialog;
            },
            scope: $scope
        })
            .then(function (value) {
                return false;
            }, function (value) {
                if ($scope.employee.profile_picture == null || $scope.employee.profile_picture == undefined || $scope.employee.profile_picture == 'No Data') {
                    $scope.employee.profile_picture = './ASSETS/img/blank.gif';
                }
                for (var i in $scope.employee.dependents) {
                    $scope.employee.dependents[i].dependent_birth_date = moment($scope.employee.dependents[i].dependent_birth_date).format("MM-DD-YYYY");
                }

                $scope.employee.work_experience = JSON.stringify($scope.employee.work_experience);
                $scope.employee.seminar_trainings = JSON.stringify($scope.employee.seminar_trainings);
                $scope.employee.educations = JSON.stringify($scope.employee.educations);
                //John Dee
                $scope.employee.government = JSON.stringify($scope.employee.government);
                $scope.employee.dependents = JSON.stringify($scope.employee.dependents);
                $scope.employee.allowances = JSON.stringify($scope.employee.allowances);
                $scope.employee.leaves_pm = JSON.stringify($scope.employee.leaves_pm);
                $scope.employee.documents = JSON.stringify($scope.employee.documents);
                $scope.employee.loans = JSON.stringify($scope.employee.loans);

                $scope.employee.date_started = moment($scope.employee.date_started).format("YYYY-MM-DD");
                $scope.employee.birth_date = moment($scope.employee.birth_date).format("YYYY-MM-DD");
                var datep = new Date($scope.employee.regularization_date);
                if ($scope.employee.regularization_date != null) {
                    $scope.employee.regularization_date = moment($scope.employee.regularization_date).format("YYYY-MM-DD");
                }
                if ($scope.employee.work_days_status.sun == true) {
                    $scope.employee.work_days += 1;
                }
                if ($scope.employee.work_days_status.mon == true) {
                    $scope.employee.work_days += 1;
                }
                if ($scope.employee.work_days_status.tue == true) {
                    $scope.employee.work_days += 1;
                }
                if ($scope.employee.work_days_status.wed == true) {
                    $scope.employee.work_days += 1;
                }
                if ($scope.employee.work_days_status.thu == true) {
                    $scope.employee.work_days += 1;
                }
                if ($scope.employee.work_days_status.fri == true) {
                    $scope.employee.work_days += 1;
                }
                if ($scope.employee.work_days_status.sat == true) {
                    $scope.employee.work_days += 1;
                }
                $scope.employee.work_days_status = JSON.stringify($scope.employee.work_days_status);

                if ($scope.employee.loan_status == undefined || $scope.employee.loan_status == 'undefined') {
                    $scope.employee.loan_status = false;
                }
                if ($scope.employee.leave_status == undefined || $scope.employee.leave_status == 'undefined') {
                    $scope.employee.leave_status = false;
                }
                $scope.employee.hremployee = JSON.stringify($scope.employee.hremployee);
                $scope.employee.emaildatereminder1 = moment($scope.employee.emaildatereminder1).format("YYYY-MM-DD");
                $scope.employee.emaildatereminder2 = moment($scope.employee.emaildatereminder2).format("YYYY-MM-DD");
                $scope.save_compensation();

                var date = new Date();
                $scope.employee.date = date;
                $scope.employee.emp_pk = $scope.profile.pk;
                $scope.employee.remarks = $scope.modal_remarks.remarks;
                for (var p in $scope.titles.data) {
                    if ($scope.employee.titless == $scope.titles.data[p].pk) {
                        $scope.employee.groupings = $scope.titles.data[p].groupings;
                    }
                }


                // $scope.employee.documents.document_supporting_document = $scope.documentee_upload;
                console.log($scope.employee.documents);

                var promise = EmployeesFactory.edit_employees($scope.employee);
                promise.then(function (data) {
                    $scope.archived = true;
                    ngDialog.openConfirm({
                        template: 'ChangesModal',
                        className: 'ngdialog-theme-plain custom-widththreesixtyhundred',
                        scope: $scope,
                        showClose: false
                    });
                    // console.log($scope.upload_documents);
                    // console.log($scope.employee.documents);
                    employees();
                })
                    .then(null, function (data) {
                        ngDialog.openConfirm({
                            template: 'ErrorChangesModal',
                            className: 'ngdialog-theme-plain custom-widththreesixtyhundred',
                            scope: $scope,
                            showClose: false
                        });
                    });
            });
        if ($scope.items[k].details.company.salary.salary_type == 4 && $scope.profile.permission.compensation != undefined) {
            ngDialog.openConfirm({
                template: 'PayrollTypeModal',
                className: 'ngdialog-theme-plain custom-widththreesixtyhundred',
                scope: $scope,
                showClose: false
            });
        }
    }

    $scope.export_pdf = function () {

        var filters = [];
        if ($scope.filter.department[0]) {
            filters.push('&departments_pk=' + $scope.filter.department[0].pk);
        }

        if ($scope.filter.level_title[0]) {
            filters.push('&levels_pk=' + $scope.filter.level_title[0].pk);
        }

        if ($scope.filter.titles[0]) {
            filters.push('&titles_pk=' + $scope.filter.titles[0].pk);
        }
        $scope.image = "dsadasdasda";

        window.open('./FUNCTIONS/Employees/employeelist_export_pdf.php?&imagess=' + $scope.image + '&status=Active' + filters.join(''));

    }
    $scope.export_excel_attrition = function () {



    }
    $scope.export_employeelist = function () {
        var filters = [];
        if ($scope.filter.department[0]) {
            filters.push('&departments_pk=' + $scope.filter.department[0].pk);
        }

        if ($scope.filter.level_title[0]) {
            filters.push('&levels_pk=' + $scope.filter.level_title[0].pk);
        }

        if ($scope.filter.titles[0]) {
            filters.push('&titles_pk=' + $scope.filter.titles[0].pk);
        }

        window.open('./FUNCTIONS/Employees/employeelist_export.php?&status=Active' + filters.join(''));

    }

    $scope.level_changed = function () {
        level_changed();
    }

    function level_changed() {
        if ($scope.employee.employee_status == 6) {
            $scope.level_class = 'hours';
            $scope.show_hours = true;
            $scope.show_regular = false;
        }
        else {
            $scope.level_class = 'orig_width';
            $scope.show_hours = false;
            $scope.show_regular = true;
        }

    }

    $scope.show_list = function () {
        list();
    }

    $scope.email_reminder=function(v){
        var date = moment(v.regularization_date).format("YYYY-MM-DD");
        var yy = moment(v.regularization_date).get('year');
        var mm = moment(v.regularization_date).get('month')+1;
        var dd = moment(v.regularization_date).get('date')-1;
        date = yy+'-'+mm+'-'+dd;
        date = new Date(date);
        var now = moment();
        var yy = moment(v.now).get('year');
        var mm = moment(v.now).get('month')+1;
        var dd = moment(v.now).get('date')+1;
        now = yy+'-'+mm+'-'+dd
        now = new Date(now);
        $scope.modal = {
            title: 'Set Email Reminder Dates',
            message: 'Instruction',
            maxdate: date,
            mindate: now,
            save: 'Ok',
            close: 'Cancel'
        };

        ngDialog.openConfirm({
            template: 'email_reminderModal',
            className: 'ngdialog-theme-plain custom-email_reminder',
            scope: $scope,
            showClose: false
        });
    }

    function list() {
        $scope.filter.pk = $scope.profile.pk;

        delete $scope.filter.departments_pk;
        if ($scope.filter.department.length > 0) {
            $scope.filter.departments_pk = $scope.filter.department[0].pk;
        }

        delete $scope.filter.titles_pk;
        if ($scope.filter.titles.length > 0) {
            $scope.filter.titles_pk = $scope.filter.titles[0].pk;
        }

        delete $scope.filter.levels_pk;
        if ($scope.filter.level_title.length > 0) {
            $scope.filter.levels_pk = $scope.filter.level_title[0].pk;
        }

        delete $scope.filter.teams_pk;
        if ($scope.filter.team_title.length > 0) {
            $scope.filter.teams_pk = $scope.filter.team_title[0].pk;
        }


        employees();
    }

    function fetch_department() {
        var filter = {
            archived: false
        }

        var promise = EmployeesFactory.get_department(filter);
        promise.then(function (data) {
            var a = data.data.result;
            $scope.employees.filters.department = [];
            for (var i in a) {
                $scope.employees.filters.department.push({
                    pk: a[i].pk,
                    name: a[i].department,
                    ticked: false
                });
            }

        })
            .then(null, function (data) {

            });
    }


    function fetch_levels() {
        var promise = EmployeesFactory.get_levels();
        promise.then(function (data) {
            var a = data.data.result;
            $scope.employees.filters.level_title = [];
            for (var i in a) {
                $scope.employees.filters.level_title.push({
                    pk: a[i].pk,
                    name: a[i].level_title,
                    ticked: false
                });
            }
        })
            .then(null, function (data) {

            });
    }  

    $scope.export_csv = function(items){
        // window.open('./FUNCTIONS/Employees/er2_csv.php');

       

        var filters = [];
        if ($scope.filter.titles.length > 0) {
            filters.push('&titles_pk=' + $scope.filter.titles[0].name);
        }
        $scope.image = "dsadasdasda";

        window.open('./FUNCTIONS/Employees/er2_csv.php?imagess=' + $scope.image + '&status=Active' + filters.join('') + '&emp=' + items[0].company_name + '&empno=' + items[0].emphid + '&empadd=' + items[0].empadd)
      

    }
    $scope.export_pdfer2 = function(items){
        var filters = [];
        if ($scope.filter.titles.length > 0) {
            filters.push('&titles_pk=' + $scope.filter.titles[0].name);
        }
        $scope.image = "dsadasdasda";

        window.open('./FUNCTIONS/Employees/er2_pdf.php?imagess=' + $scope.image + '&status=Active' + filters.join('') + '&emp=' + items[0].company_name + '&empno=' + items[0].emphid + '&empadd=' + items[0].empadd)
        // $scope.image = "dsadasdasda";

        // window.open('./FUNCTIONS/Employees/employeelist_export_pdf.php?&imagess=' + $scope.image + '&status=Active' + filters.join(''));

	}
        
    function fetch_er2() {
      
    
        var promise = EmployeesFactory.get_er2($scope.filter);
        promise.then(function (data) {
            $scope.form.data = data.data.result;
            $scope.form.status1 = true;
        })   
        .then(null, function(data){
           $scope.form.status1 = false;
        });
    }

    function fetch_er22() {
      
        if ($scope.filter.type.length > 0) {
            $scope.filter.type = $scope.filter.type[0].name;
        }
        var promise = EmployeesFactory.get_er2($scope.filter);
        promise.then(function (data) {
            $scope.form.data = data.data.result;
            $scope.form.status1 = true;
        })   
        .then(null, function(data){
           $scope.form.status1 = false;
        });
    }
    function fetch_er222() {
      
        if ($scope.filter.titles.length > 0) {
            $scope.filter.title = $scope.filter.titles[0].name;
        }
        var promise = EmployeesFactory.get_er2($scope.filter);
        promise.then(function (data) {
            $scope.form.data = data.data.result;
            $scope.form.status1 = true;
        })   
        .then(null, function(data){
           $scope.form.status1 = false;
        });
    }

    function fetch_er2emp() {
        var filter = {
            archived: false
        }
        var promise = EmployeesFactory.get_er2emp();
        promise.then(function (data) {
            $scope.filter.types = data.data.result;
            $scope.form.status1 = true;
        })   
        .then(null, function(data){
           $scope.form.status1 = false;
        });
    }




    function fetch_teams() {
        var promise = EmployeesFactory.get_teams();
        promise.then(function (data) {
            var a = data.data.result;
            $scope.employees.filters.team_title = [];
            for (var i in a) {
                $scope.employees.filters.team_title.push({
                    pk: a[i].pk,
                    name: a[i].team_title,
                    ticked: false
                });
            }
        })
            .then(null, function (data) {

            });
    }

    function fetch_titles() {
        var promise = EmployeesFactory.get_positions();
        promise.then(function (data) {
            var a = data.data.result;
            $scope.employees.filters.titles = [];
            for (var i in a) {
                $scope.employees.filters.titles.push({
                    pk: a[i].pk,
                    name: a[i].title,
                    ticked: false
                });
            }
        })
            .then(null, function (data) {
            });
    }
    $scope.autolist = function(){
                    
            }
    $scope.er2btn = function(){

        $scope.modal = {
            title           : 'Add New Request type',
            save            : 'Add',
            close           : 'Cancel',
            obj_recipients  : []
         
        };

        ngDialog.openConfirm({
            template: 'FormModalView',
            className: 'ngdialog-theme-plain custom-width900',
            preCloseCallback: function(value) {
                var nestedConfirmDialog;
                nestedConfirmDialog = ngDialog.openConfirm({
                    template:
                    '<div style="width: 100%" align="center" >' +
                    '<img src="ASSETS/img/logo_black_white.png" style="height: 45px;">' +
                    '</div>' +
                    '<hr style="margin-top: -2px;">' +
                    '<div><center><b><p style="font-size: 15px;font-family: muli; color: #fff;">Are you sure you want to add this employee?</p></b></center></div>' +
                    '<div class="ngdialog-buttons">' +
                    '<button type="button" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-secondary" data-ng-click="closeThisDialog(0)">No' +
                    '<button type="button" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-primary" data-ng-click="confirm(1)">Yes' +
                    '</button></div>',
                    plain: true,
                    className: 'ngdialog-theme-plain customer2'
                });
                return nestedConfirmDialog;
            },
            scope: $scope,
            showClose: false
        })
        .then(function(value){
            return false;
        }, function(value){
            var date = new Date($scope.er2.effdate);
            var today = date;
            $scope.er2.position = $scope.filter.types12[0].name;
            $scope.er2.empname = $scope.filter.type123[0].name;
            $scope.er2.employerno = $scope.filter.types.empno;
            $scope.data = {
                empnumber       : $scope.er2.number,
                namee           : $scope.er2.namee,
                address         : $scope.er2.address,
                email           : $scope.er2.email,
                position        : $scope.er2.position,
                salary          : $scope.er2.salary,
                employerno      : $scope.er2.employerno,
                emploname       : $scope.er2.empname,
                empprev         : $scope.er2.empprev,
                empdate         : $scope.er2.empdate,
                effdate         : $scope.er2.effdate,
                date            : today   
            }
            var promise = EmployeesFactory.adder2($scope.data);
            promise.then(function(data){
                ngDialog.openConfirm({
                    template: 'addModal',
                    className: 'ngdialog-theme-plain custom-widththreesixtyhundred',
                    preCloseCallback: function(value) {
                    },
                    scope: $scope,
                    showClose: false
                })
                .then(function(value){
                    return false;
                }, function(value){
                });  

                fetch_er2();
            }).then(null, function(data){
            ngDialog.openConfirm({
                template: 'ErrorAddModal',
                className: 'ngdialog-theme-plain custom-widththreesixtyhundred',
                preCloseCallback: function(value) {
                },
                scope: $scope,
                showClose: false
            })
            .then(function(value){
                return false;
            }, function(value){
            });  
        });         
        });
        
    }
    
    $scope.editer2btn = function(v){
        $scope.madal = v;
        console.log($scope.madal);
        $scope.madal.philno = parseInt(v.philno);
        $scope.madal.salary = parseInt(v.salary);
        $scope.madal.empno = parseInt(v.empno);
        $scope.madal.effdate = new Date(v.effdate);
        $scope.madal.empdate = new Date(v.empdate);
        $scope.modal = {
            title           : 'Edit Details',
            save            : 'Save',
            close           : 'Cancel',
            obj_recipients  : []
         
        };
     

        ngDialog.openConfirm({
            template: 'EditView',
            className: 'ngdialog-theme-plain custom-width900',
            preCloseCallback: function(value) {
                var nestedConfirmDialog;
                nestedConfirmDialog = ngDialog.openConfirm({
                    template:
                    '<div style="width: 100%" align="center">' +
                    '<img src="ASSETS/img/logo_black_white.png" style="height: 45px;">' +
                    '</div>' +
                    '<hr style="margin-top: -2px;">' +
                    '<div><center><b><p style="font-size: 15px;font-family: muli; color: #fff;">Are you sure you want to save changes?</p></b></center></div>' +
                    '<div class="ngdialog-buttons">' +
                    '<button type="button" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-secondary" data-ng-click="closeThisDialog(0)">No' +
                    '<button type="button" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-primary" data-ng-click="confirm(1)">Yes' +
                    '</button></div>',
                    plain: true,
                    className: 'ngdialog-theme-plain customedit'
                });
                return nestedConfirmDialog;
            },
            scope: $scope,
            showClose: false
        })
        .then(function(value){
            fetch_er2();
            fetch_er2emp();
            return false;
        }, function(value){
            var date = new Date();
            var today = date;
            $scope.data = {
                id              : $scope.madal.id,
                philno          : $scope.madal.philno,
                empnumber       : $scope.madal.empno,
                namee           : $scope.madal.name,
                address         : $scope.madal.address,
                email           : $scope.madal.email,
                position        : $scope.madal.position,
                salary          : $scope.madal.salary,
                emploname       : $scope.madal.empname,
                empprev         : $scope.madal.empprev,
                empdate         : $scope.madal.empdate,
                effdate         : $scope.madal.effdate,
                date            : today   
            }
            var promise = EmployeesFactory.editer2($scope.data);
            promise.then(function(data){
                ngDialog.openConfirm({
                    template: 'editModal',
                    className: 'ngdialog-theme-plain customedit2',
                    preCloseCallback: function(value) {
                    },
                    scope: $scope,
                    showClose: false
                })
                .then(function(value){
                    return false;
                }, function(value){
                });  

                fetch_er2();
            }).then(null, function(data){
            ngDialog.openConfirm({
                template: 'ErrorAddModal',
                className: 'ngdialog-theme-plain custom-widththreesixtyhundred',
                preCloseCallback: function(value) {
                },
                scope: $scope,
                showClose: false
            })
            .then(function(value){
                return false;
            }, function(value){
            });  
        });         
        });
        
    }
    $scope.deleter2btn = function (k) {

        var date = new Date();
        $scope.modal = {
            title: '',
            message: '',
            save: 'Delete',
            close: 'Cancel'
        };

        ngDialog.openConfirm({
            template: 'AddModal',
            className: 'ngdialog-theme-plain',
            preCloseCallback: function (value) {
                var nestedConfirmDialog;

                nestedConfirmDialog = ngDialog.openConfirm({
                    template:
                        '<div style="width: 100%" align="center">' +
                        '<img src="ASSETS/img/logo_black_white.png" style="height: 45px;">' +
                        ' </div>' +
                        '<hr style="margin-top: -2px;">' +
                        '<p style="font-family: muli; color: #fff;"><b>Are you sure you want Delete?</b></p>' +
                        '<div class="ngdialog-buttons">' +
                        '<button type="button" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-secondary" data-ng-click="closeThisDialog(0)">No' +
                        '<button type="button" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-primary" data-ng-click="confirm(1)">Yes' +
                        '</button></div>',
                    plain: true,
                    className: 'ngdialog-theme-plain custom-widththreefifty'
                });

                return nestedConfirmDialog;
            },
            scope: $scope,
            showClose: false
        })


            .then(function (value) {
                return false;
            }, function (value){
                $scope.modal.last_day_work_new = new Date($scope.modal.last_day_works);
                $scope.modal.last_day_work = moment($scope.modal.last_day_work_new).format("YYYY-MM-DD");
                $scope.modal.effective_date_new = new Date($scope.modal.effective_dates);
                $scope.modal.effective_date = moment($scope.modal.effective_date_new).format("YYYY-MM-DD");
                $scope.modal["created_by"] = $scope.profile.pk;
                $scope.modal["supervisor_pk"] = $scope.profile.supervisor_pk;
                $scope.modal["pk"] = $scope.items[k].pk;
                $scope.modal["name"] = $scope.items[k].details.personal.first_name + " " + $scope.items[k].details.personal.middle_name + " " + $scope.items[k].details.personal.last_name;
                $scope.modal["date"] = date;
                var promise = EmployeesFactory.delete_employees($scope.modal);
                promise.then(function (data) {
                    $scope.archived = true;
                    ngDialog.openConfirm({
                        template: 'DeleteModal',
                        className: 'ngdialog-theme-plain custom-widththreesixtyhundred',
                        preCloseCallback: function (value) {
                        },
                        scope: $scope,
                        showClose: false
                    })
                        .then(function (value) {
                            return false;
                        }, function (value) {
                        });
                    employees();
                })
                    .then(null, function (data) {
                        ngDialog.openConfirm({
                            template: 'ErrorDeleteModal',
                            className: 'ngdialog-theme-plain custom-widththreesixtyhundred',
                            preCloseCallback: function (value) {
                            },
                            scope: $scope,
                            showClose: false
                        })
                            .then(function (value) {
                                return false;
                            }, function (value) {
                            });
                    });
            });
    }

    
    $scope.view = function(v){
        // <td><center>{{v.details.government.data_tin}}</center></td>
        //                         <td><center>{{v.details.personal.last_name}},
        //                             {{v.details.personal.first_name}}
        //                             {{v.details.personal.middle_name}}</center></td>
        //                         <td><center>{{v.title}}</center></td>
        //                         <td><center>{{v.details.company.salary.details.monthly_amount | currency: "&#8369&nbsp;":0}}</center></td>
        //                         <td><center>{{v.details.company.date_started}}</center></td>
        //                         <td><center>{{v.effdate}}</center></td>
        console.log(v);
        if(v.details.company.salary.details.monthly_amount === undefined){
            $scope.modal.salary = 0;
        }
        var monthNames = [
            "January", "February", "March",
            "April", "May", "June", "July",
            "August", "September", "October",
            "November", "December"
          ];
        
          var day = new Date(v.details.company.date_started);
          console.log(day);
        //   var monthIndex = date.getMonth();
        //   var year = date.getFullYear();
        var fullname = v.details.personal.last_name + ', ' + v.details.personal.first_name + ' ' + v.details.personal.middle_name;
        $scope.modal = {
            title           : 'Add New Request type',
            save            : 'Add',
            close           : 'Cancel',
            obj_recipients  : [],
            tin             : v.emphid,
            empnumber       : v.details.government.data_phid,
            empnumbersss    : v.details.government.data_sss,
            company_name    : v.company_name,
            namee           : fullname,
            address         : v.details.personal.permanent_address,
            email           : v.details.company.business_email_address,
            position        : v.title,
           
            employerno      : v.empno,
            emploname       : v.empname,
            empprev         : v.empprev,
            empdate         : v.details.company.date_started,
            effdate         : v.effdate
            
        };
  
        ngDialog.openConfirm({
            template: 'viewModal',
            className: 'ngdialog-theme-plain custom-width9',
            preCloseCallback: function(value) {
                var nestedConfirmDialog;
                nestedConfirmDialog = ngDialog.openConfirm({
                    template:
                    '<div style="width: 100%" align="center">' +
                    '<img src="ASSETS/img/logo_black_white.png" style="height: 45px;">' +
                    '</div>' +
                    '<hr style="margin-top: -2px;">' +
                    '<div><center><b><p style="font-size: 15px;font-family: muli; color: #fff;">Are you sure you want to add this Request Type?</p></b></center></div>' +
                    '<div class="ngdialog-buttons">' +
                    '<button type="button" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-secondary" data-ng-click="closeThisDialog(0)">No' +
                    '<button type="button" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-primary" data-ng-click="confirm(1)">Yes' +
                    '</button></div>',
                    plain: true,
                    className: 'ngdialog-theme-plain custom-width9'
                });
                return nestedConfirmDialog;
            },
            scope: $scope,
            showClose: false
        })
        .then(function(value){
            return false;
        }, function(value){
            var date = new Date();
            var today = date;
            $scope.data = {
                empnumber       : $scope.er2.number,
                namee           : $scope.er2.namee,
                address         : $scope.er2.address,
                email           : $scope.er2.email,
                position        : $scope.er2.position,
                salary          : $scope.er2.salary,
                employerno      : $scope.er2.employerno,
                emploname       : $scope.er2.empname,
                empprev         : $scope.er2.empprev,
                empdate         : $scope.er2.empdate,
                effdate         : $scope.er2.effdate,
                date            : today   
            }
            var promise = EmployeesFactory.adder2($scope.data);
            promise.then(function(data){
                ngDialog.openConfirm({
                    template: 'addModal',
                    className: 'ngdialog-theme-plain custom-width9',
                    preCloseCallback: function(value) {
                    },
                    scope: $scope,
                    showClose: false
                })
                .then(function(value){
                    return false;
                }, function(value){
                });  

                fetch_er2();
            }).then(null, function(data){
            ngDialog.openConfirm({
                template: 'ErrorAddModal',
                className: 'ngdialog-theme-plain custom-widththreesixtyhundred',
                preCloseCallback: function(value) {
                },
                scope: $scope,
                showClose: false
            })
            .then(function(value){
                return false;
            }, function(value){
            });  
        });         
        });
    }


    $scope.addemp = function(){
        $scope.modal = {
            title           : 'Add New Employer',
            save            : 'Add',
            close           : 'Cancel',
            obj_recipients  : []
        };
        

        ngDialog.openConfirm({
            template: 'addempModal',
            className: 'ngdialog-theme-plain custom-widthfoursixty',
            preCloseCallback: function(value) {
                var nestedConfirmDialog;
                nestedConfirmDialog = ngDialog.openConfirm({
                    template:
                    '<div style="width: 100%" align="center">' +
                    '<img src="ASSETS/img/logo_black_white.png" style="height: 45px;">' +
                    '</div>' +
                    '<hr style="margin-top: -2px;">' +
                    '<div><center><b><p style="font-size: 15px;font-family: muli; color: #fff;">Are you sure you want to add this Employer?</p></b></center></div>' +
                    '<div class="ngdialog-buttons">' +
                    '<button type="button" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-secondary" data-ng-click="closeThisDialog(0)">No' +
                    '<button type="button" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-primary" data-ng-click="confirm(1)">Yes' +
                    '</button></div>',
                    plain: true,
                    className: 'ngdialog-theme-plain custom-widthfoursixty'
                });
                return nestedConfirmDialog;
            },
            scope: $scope,
            showClose: false
        })
        .then(function(value){
            return false;
        }, function(value){
            $scope.data = {
                employerno      : $scope.er2.employerno,
                emploname       : $scope.er2.empname 
            }
            if($scope.data.employerno == null){
                $scope.data.employerno === false;
                $scope.modal = {msg1:'Employer No. is Empty'};
                return false;
                
            }
            if($scope.data.emploname == null){
                $scope.data.emploname === false;
                $scope.modal = {msg2:'Employer Name is Empty'};
                return false;
            }
            
            var promise = EmployeesFactory.addemp($scope.data);
            promise.then(function(data){
                ngDialog.openConfirm({
                    template: 'addModal',
                    className: 'ngdialog-theme-plain custom-widththreesixtyhundred',
                    preCloseCallback: function(value) {
                    },
                    scope: $scope,
                    showClose: false
                })
                .then(function(value){
                    return false;
                }, function(value){
                });  
                fetch_er2emp();
                fetch_er2();
            }).then(null, function(data){
            ngDialog.openConfirm({
                template: 'ErrorAddModal',
                className: 'ngdialog-theme-plain custom-widththreesixtyhundred',
                preCloseCallback: function(value) {
                },
                scope: $scope,
                showClose: false
            })
            .then(function(value){
                return false;
            }, function(value){
            });  
        });         
        });
    }



    var uploader = $scope.uploader = new FileUploader({
        url: 'FUNCTIONS/Employees/upload_profile_pic.php'
    });



    uploader.filters.push({
        name: 'customFilter',
        fn: function (item, options) {
            return this.queue.length < 10;
        }
    });



    uploader.onWhenAddingFileFailed = function (item, filter, options) {

    };
    uploader.onAfterAddingFile = function (fileItem) {

    };
    uploader.onAfterAddingAll = function (addedFileItems) {

    };
    uploader.onBeforeUploadItem = function (item) {

    };
    uploader.onProgressItem = function (fileItem, progress) {

    };
    uploader.onProgressAll = function (progress) {

    };
    uploader.onSuccessItem = function (fileItem, response, status, headers) {

    };
    uploader.onErrorItem = function (fileItem, response, status, headers) {

    };
    uploader.onCancelItem = function (fileItem, response, status, headers) {

    };
    uploader.onCompleteItem = function (fileItem, response, status, headers) {

        $scope.employee.profile_picture = response.file;

    };
    uploader.onCompleteAll = function () {

    };


    // var docUploader = $scope.uploader = new FileUploader({
    //     url: 'FUNCTIONS/Employees/upload_document.php'
    // });



    // docUploader.filters.push({
    //     name: 'customFilter',
    //     fn: function (item, options) {
    //         return this.queue.length < 10;
    //     }
    // });



    // docUploader.onWhenAddingFileFailed = function (item, filter, options) {

    // };
    // docUploader.onAfterAddingFile = function (fileItem) {

    // };
    // docUploader.onAfterAddingAll = function (addedFileItems) {

    // };
    // docUploader.onBeforeUploadItem = function (item) {

    // };
    // docUploader.onProgressItem = function (fileItem, progress) {

    // };
    // docUploader.onProgressAll = function (progress) {

    // };
    // docUploader.onSuccessItem = function (fileItem, response, status, headers) {

    // };
    // docUploader.onErrorItem = function (fileItem, response, status, headers) {

    // };
    // docUploader.onCancelItem = function (fileItem, response, status, headers) {

    // };
    // docUploader.onCompleteItem = function (fileItem, response, status, headers) {

    //     $scope.employee.profile_picture = response.file;

    //     $scope.documentee_upload = response.file;

    //     console.log(response.file)
    // };
    // docUploader.onCompleteAll = function () {

    // };



    var uploader_dependent = $scope.uploader_dependent = new FileUploader({
        url: 'FUNCTIONS/Employees/upload_document.php'
    });



    uploader_dependent.filters.push({
        name: 'customFilter',
        fn: function (item, options) {
            return this.queue.length < 10;
        }
    });


    uploader_dependent.onWhenAddingFileFailed = function (item, filter, options) {

    };
    uploader_dependent.onAfterAddingFile = function (fileItem) {

    };
    uploader_dependent.onAfterAddingAll = function (addedFileItems) {

    };
    uploader_dependent.onBeforeUploadItem = function (item) {

    };
    uploader_dependent.onProgressItem = function (fileItem, progress) {

    };
    uploader_dependent.onProgressAll = function (progress) {

    };
    uploader_dependent.onSuccessItem = function (fileItem, response, status, headers) {

    };
    uploader_dependent.onErrorItem = function (fileItem, response, status, headers) {

    };
    uploader_dependent.onCancelItem = function (fileItem, response, status, headers) {

    };
    uploader_dependent.onCompleteItem = function (fileItem, response, status, headers) {
        $scope.dependent_upload = response.file;

        $scope.documentee_upload = response.file;

        $scope.addDocuDisabled = false;

        console.log($scope.documentee_upload);

        // console.log($scope.documentee_upload);
    };
    uploader_dependent.onCompleteAll = function () {

    };


    $scope.save_compensation = function () {
        var promise = EmployeesFactory.save_compensation($scope.employee);
        promise.then(function (data) {
            // apply();
        })
            .then(null, function (data) {
                ngDialog.openConfirm({
                    template: 'ErrorChangesModal',
                    className: 'ngdialog-theme-plain custom-widththreesixtyhundred',
                    preCloseCallback: function (value) {
                    },
                    scope: $scope,
                    showClose: false
                })
                    .then(function (value) {
                        return false;
                    }, function (value) {
                    });
            });

        // function apply(){
        //     $scope.modal_remarks = {
        //         title : 'Reason for Editing',
        //         remarks : ''
        //     }
        //     ngDialog.openConfirm({
        //         template: 'ApplyModal',
        //         className: 'ngdialog-theme-plain custom-applymodal',
        //         preCloseCallback: function(value) {
        //         },
        //         scope: $scope,
        //         showClose: false
        //     })
        //     .then(function(value){
        //         return false;
        //     }, function(value){
        //         var date = new Date();
        //         $scope.employee.date = date;
        //         $scope.employee.emp_pk = $scope.profile.pk;
        //         $scope.employee.remarks = $scope.modal_remarks.remarks;
        //         for (var p in $scope.titles.data) {
        //             if($scope.employee.titless == $scope.titles.data[p].pk){
        //                 $scope.employee.groupings = $scope.titles.data[p].groupings;
        //             }
        //         }
        //         var promise = EmployeesFactory.edit_employees($scope.employee);
        //         promise.then(function(data){
        //             $scope.archived=true;
        //             ngDialog.openConfirm({
        //                 template: 'ChangesModal',
        //                 className: 'ngdialog-theme-plain custom-widththreesixtyhundred',
        //                 preCloseCallback: function(value) {
        //                 },
        //                 scope: $scope,
        //                 showClose: false
        //             })
        //             .then(function(value){
        //                 return false;
        //             }, function(value){
        //             });
        //             employees();
        //         })
        //         .then(null, function(data){
        //             ngDialog.openConfirm({
        //                 template: 'ErrorChangesModal',
        //                 className: 'ngdialog-theme-plain custom-widththreesixtyhundred',
        //                 preCloseCallback: function(value) {
        //                 },
        //                 scope: $scope,
        //                 showClose: false
        //             })
        //             .then(function(value){
        //                 return false;
        //             }, function(value){
        //             });
        //         });
        //     });
        //}
    }
});






//////////////////////////////////////////////////////////
<style type="text/css">
    .red {
        color: #ff0000;
    }

    .total {
        margin-right: 120px;
        float: left;
        margin-bottom: 10px;
        font-size: 15px;
    }

    .bck {
        background-color: #F9F9F9;
        height: 80px;
        width: 100%;
        margin-left: -8px;
        border-radius: 5px;
        border: 1px solid #dbd9d9;
    }

    .total {
        margin-left: 60px;
        float: left;
        margin-bottom: 10px;
        font-size: 15px;
    }

    .tblemployees td {
        border: 0px;
        background-color: #F0F0F0;
        width: 150px;
    }

    .tblemployees1 td {
        border: 0px;
        background-color: #666666;
        width: 2px;
    }

    .table1 {
        width: 98.3%;
        margin: 0 auto;
        background-color: white;
        font-size: 12px;
        margin-top: 3px;
        table-layout: fixed;
        word-wrap: break-word;
    }

    th,
    td {
        text-align: left;
        padding: 8px;
        color: #3d3d3d;
        border: 1px solid #c6c6c6;
        overflow: hidden;
        word-break: break-all;
    }

    tr:nth-child(odd) {
        background-color: #F9F9F9;
    }

    th {
        font-size: 13px;
        background-color: white;
        color: #3d3d3d;
        border: 1px solid #c6c6c6;
    }

    select {
        background-color: #FBFBFB;
        color: #433D43;
        padding: 6px;
        display: inline-block;
        text-transform: uppercase;
        font-weight: 900;

    }

    @font-face {
        font-family: 'Raleway', sans-serif;
        font-family: 'Lato', sans-serif;
        font-family: 'Roboto', sans-serif;
        font-family: 'Muli', sans-serif;
    }
</style>

<div id="content2">
    <div class="panel box-shadow-none content-header">
        <div class="panel-body">
            <div class="col-md-12">
                <h3 class="animated fadeInLeft">HRIS</h3>
                <p class="animated fadeInDown">
                    <a href="#/" style="color: black">Home</a> <span class="fa-angle-right fa"></span>
                    HRIS

                </p>
            </div>
        </div>
    </div>
    <div style="width:83%;color:white ; font-size: 12px;border:3px solid black;border-radius: 7px;border-color:#24A60F;box-shadow: 3px 6px #888888;padding: 8px;background-color:#24A60F;opacity: 0.75">
        <p style="color:white; font-size:12px;">
            <i class="fa fa-lightbulb-o" style="font-size: 14px"></i><b style="font-size: 14px;color: white"> PANDAS
                Tips</b> :
            <ul>
                <li style="color: white; font-size: 11px"><span style="color: yellow" class="glyphicon glyphicon-leaf"></span>&nbsp;You
                    can search an individual detail of an employee by typing his first name, middle name, last name, or
                    employee ID. You can also select details by selecting by department, by level, or by position.</li>
                <li style="color: white; font-size: 11px"><span style="color: yellow" class="glyphicon glyphicon-leaf"></span>&nbsp;The
                    list of items for departments, levels, and positions are filled up by administrators.</li>
                <li style="color: white; font-size: 11px"><span style="color: yellow" class="glyphicon glyphicon-leaf"></span>&nbsp;You
                    can download the details by excel or pdf type. Click the "Export" button for excel file and "Export
                    PDF" button for pdf file.</li>
                <li style="color: white; font-size: 11px"><span style="color: yellow" class="glyphicon glyphicon-leaf"></span>&nbsp;To
                    tag a separated employee as inactive click the red "x" button found in Options Column and a modal
                    box will ask for the effective date of resignation.</li>
            </ul>
        </p>
    </div>
    <div style="height:35px; width:100%;">
    </div>
    <br>
    <br>
    <div class="panel">
        <div style="padding-left: 20px; padding-top:5px;">
            <div class="bck">
                <div style="float:left; margin-left:20px;margin-top: 14px;">
                    <label style="float:left;font-size: 13px;">Search</label><br>
                    <input ng-model="filter.searchstring" type="text" style="width:230px; margin-left:-43px;float:left"
                        ng-change="show_employees()" placeholder="Search for Name or Employee ID" />
                    <select ng-model="filter.status" style="float:left;width:100px;margin-left:235px;
                        margin-top:-32px;"
                        ng-change="show_employees()">
                        <option>Active</option>
                        <option>Inactive</option>

                    </select>
                </div>

                <div style="float:left; margin-left:-178px;margin-top: 10px;margin-right: 6px;">
                    <label style="float:left;font-size: 13px;">Select a Department</label><br>
                    <div isteven-multi-select input-model="employees.filters.department" output-model="filter.department"
                        button-label="icon name" item-label="icon name maker" tick-property="ticked" selection-mode="single"
                        style="width:150px; float:left;" max-height="200px">
                    </div>
                    </br>
                </div>

                <div style="float:left; margin-top: 10px;margin-left:-18px;margin-right:10px;">
                    <label style="float:left;font-size: 13px;">Select a Level</label><br>
                    <div isteven-multi-select input-model="employees.filters.level_title" output-model="filter.level_title"
                        button-label="icon name" item-label="icon name maker" tick-property="ticked" selection-mode="single"
                        style="width:150px; float:left;" max-height="200px">
                    </div>
                    </br>
                </div>

                <div style="float:left; margin-top: 10px;margin-right: 10px;">
                    <label style="float:left;font-size: 13px;">Select a Position</label><br>

                    <div isteven-multi-select input-model="employees.filters.titles" output-model="filter.titles"
                        button-label="icon name" item-label="icon name maker" tick-property="ticked" selection-mode="single"
                        style="width:150px;float:left;" max-height="200px">
                    </div>
                    </br>

                </div>
                <div style="float:left; margin-top:33px;margin-right:15px;">
                    <input type="button" class="medium button white fa-fa" value="&#xf002; SEARCH" ng-click="show_list()"
                        style="float:left; ">
                </div>
                <div style="float:left; margin-top:33px;">

                    <input type="button" class="medium button white fa-fa" value="&#xf1c3; EXPORT" ng-click="export_employeelist()"
                        ; style="float:left;margin-right:10px;">
                    <input type="button" class="medium button white fa-fa" value="&#xf1c3; EXPORT PDF" ng-click="export_pdf()"
                        ; style="float:left;margin-right:10px;">
                    <a href="#/employees/new"><input type="button" class="medium button white fa-fa" value="&#xf055; ADD NEW EMPLOYEE"
                            style="float:left;margin-right:1px;"></a>
                </div>
            </div>
        </div>
    </div>

    <div>
        <div style="height:10px; width:100%;">

        </div>

        <div style="width:98%;">
            <div style="width:20%; float:left;">
                <b class="total">Total: {{employees.count}}</b>
            </div>
            <div style="width:80%; float:left; text-align:right;">
                <select ng-model="filter.max_count" ng-change="setPage(1)">
                    <option>1</option>
                    <option>5</option>
                    <option>10</option>
                    <option>20</option>
                    <option>50</option>
                    <option>100</option>
                </select>
            </div>
        </div>

        <div>
            <table id="datatables-example" class="table1" width="100%" cellspacing="0">
                <thead>
                    <tr>
                        <!-- <th>Database No.</th> -->
                        <th>Employee #</th>
                        <th>Company Name</th>
                        <th>Name</th>
                        <th>E-mails</th>
                        <th>Supervisor</th>
                        <th>Position</th>
                        <th>Level</th>
                        <th>Department</th>
                        <th>Team</th>
                        <th>Options</th>
                    </tr>
                </thead>
                <tbody>
                    <tr ng-repeat="(k, v) in items" style="cursor:pointer;" ng-if="employees.status" title="View">
                        <!-- <td title="View">{{v.pk}}</td> -->
                        <td title="View"><a ng-href="#/employees/view/{{v.employee_id}}" style="text-decoration: none; color: #5a5a5b; font-weight:normal;"
                                target="_blank">{{v.details.company.employee_id}}</a></td>
                        <td title="View"><a ng-href="#/employees/view/{{v.employee_id}}" style="text-decoration: none; color: #5a5a5b; font-weight:normal;"
                                target="_blank">
                                <span ng-hide="v.subcompanyChecker">
                                    {{v.company_name}}
                                </span>
                                <span ng-show="v.subcompanyChecker">
                                    {{v.subcompany}}
                                </span>
                            </a></td>
                        <td title="View">
                            <div ng-if="v.details.personal.last_name && v.details.personal.first_name">
                                <a ng-href="#/employees/view/{{v.employee_id}}" style="text-decoration: none; color: #5a5a5b; font-weight:normal;"
                                    target="_blank">{{v.details.personal.last_name}},
                                    {{v.details.personal.first_name}}
                                    {{v.details.personal.middle_name}}</a>
                            </div>
                        </td>
                        <td title="View">
                            <div><a ng-href="#/employees/view/{{v.employee_id}}" style="text-decoration: none; color: #5a5a5b; font-weight:normal;"
                                    target="_blank">{{v.details.personal.email_address}}</a></div>
                            <div><a ng-href="#/employees/view/{{v.employee_id}}" style="text-decoration: none; color: #5a5a5b; font-weight:normal;"
                                    target="_blank">{{v.details.company.business_email_address}}</a></div>
                        </td>
                        <td title="View">
                            <a ng-href="#/employees/view/{{v.employee_id}}" style="text-decoration: none; color: #5a5a5b; font-weight:normal;"
                                target="_blank">{{v.supervisor}}</a>
                            <!-- <div ng-repeat = "(k, v) in groupings.data" style="cursor:pointer;" value="{{v.pk}}" ng-if="employees.status"> {{v.supervisor_pk}}</div> -->
                        </td>
                        <td title="View"><a ng-href="#/employees/view/{{v.employee_id}}" style="text-decoration: none; color: #5a5a5b; font-weight:normal;"
                                target="_blank">{{v.title}}</a></td>
                        <td title="View">
                            <div><a ng-href="#/employees/view/{{v.employee_id}}" style="text-decoration: none; color: #5a5a5b; font-weight:normal;"
                                    target="_blank">{{v.level}}</a></div>
                            <div><a ng-href="#/employees/view/{{v.employee_id}}" style="text-decoration: none; color: #5a5a5b; font-weight:normal;"
                                    target="_blank">{{v.details.company.hours}}</a><span ng-if="v.details.company.hours">hrs</span></div>
                        </td>
                        <td title="View"><a ng-href="#/employees/view/{{v.employee_id}}" style="text-decoration: none; color: #5a5a5b; font-weight:normal;"
                                target="_blank">{{v.department}}</a></td>
                        <td title="View"><a ng-href="#/employees/view/{{v.employee_id}}" style="text-decoration: none; color: #5a5a5b; font-weight:normal;"
                                target="_blank">{{v.team_name}}</a></td>
                        <td>
                            <center> </a>
                                <input type="image" src="ASSETS/img/edit.png" alt="edit" style="width:16px; height:16px;margin-right:4px;"
                                    ng-click="edit_employees(k)" title="Edit">



                                <input type="image" src="ASSETS/img/delete.png" alt="delete" style="width:14px; height:14px"
                                    ng-if="v.archived=='f'" ng-click="delete_employees(k)" title="Deactivate">

                                <input type="image" src="ASSETS/img/activate.png" alt="delete" style="width:16px; height:16px"
                                    ng-if="v.archived=='t'" ng-click="activate_employees(k)" title="Activate">

                            </center>
                        </td>
                    </tr>
                    <tr ng-if="!employees.status" style="text-align: center;">
                        <td colspan="10" style="text-align:center;">No Data Found</td>
                    </tr>
                </tbody>
            </table>
        </div>

        <div style="text-align:right;">
            <!-- pager -->
            <ul ng-if="pager.pages.length" class="pagination">
                <li ng-class="{disabled:current_page === 1}">
                    <a ng-click="setPage(1)" style="color: black">First</a>
                </li>
                <li ng-class="{disabled:current_page === 1}">
                    <a ng-click="setPage(current_page - 1)" style="color: black">Previous</a>
                </li>
                <li ng-repeat="page in pager.pages" ng-class="{active:current_page === page}">
                    <a ng-click="setPage(page)" style="color: black">{{page}}</a>
                </li>
                <li ng-class="{disabled:current_page === pager.totalPages}">
                    <a ng-click="setPage(current_page + 1)" style="color: black">Next</a>
                </li>
                <li ng-class="{disabled:current_page === pager.totalPages}">
                    <a ng-click="setPage(pager.totalPages)" style="color: black">Last</a>

                </li>

            </ul>
        </div>

        <div style="height:50px; width:100%;">

        </div>
    </div>


    <script type="text/ng-template" id="EditModal" class="ngdialog-buttons">
    <div class="ngdialog-message" style="width: 100%;">
    <div style="margin-top: -5px; width: 50%; float: left;">
    <h3><span style="font-family: muli; color: #fff; margin-left:25px; margin-top: -20px;"><b>{{ modal.title }}</b></span></h3>
    </div>
    <div style="width: 50%; float: right;">
        <img src="./ASSETS/img/logo_black_white.png" style="height: 45px; float: right; margin-top: -20px;" >
    </div>
    <link href="https://fonts.googleapis.com/css?family=Lato|Muli|Raleway|Roboto" rel="stylesheet">
    
    <style type="text/css">
    #submit {
        color: #2196f3 !important;
    }
    
    #submit:hover{
        background-color: #e7e7e7;
    }
    
    body>footer {
        /*background-color: #eee;*/
        font-size: 11px;
        position: fixed;
        bottom: 0;
        padding: 8px;
        /*width: 100%;*/
        width: 400px;
    
        max-height: 450px;
        display: block;
    
        /*additional remove to make a footer and uncomment comments above*/
        margin-left: 75%;
    }
    
    body>footer .footer-main {
        width: 100%;
        text-align: right;
    }
    
    .red {
        color: #ff0000;
    }
    
    .container {
        width: 500px;
        clear: both;
    }
    .container input {
        width: 100%;
        clear: both;
    }
    #css .ng-dirty.ng-valid {
        border:1px solid Green;
    }
    #css .ng-dirty.ng-invalid {
        border:1px solid Red;
    }
    
    </style>
    <style type="text/css">
    #tabs {
        overflow: hidden;
        width: 100%;
        margin: 0;
        padding: 0;
        list-style: none;
    }
    
    #tabs li {
        float: left;
        margin: 0 0 0 0;
    }
    
    #tabs a {
        position: relative;
        background: #ddd;
        /*background-image: linear-gradient(to bottom, #fff, #ddd);*/
        padding: .3em 1.6em;
        float: left;
        text-decoration: none;
        color: #444;
        text-shadow: 0 1px 0 rgba(255,255,255,.8);
        border-radius: 5px 5px 0 0;
        /*  box-shadow: 0 2px 2px rgba(0,0,0,.4);*/
    }
    
    /*#tabs a:hover,
    #tabs a:hover::after,
    #tabs a:focus,
    #tabs a:focus::after {
    background: #fff;
    z-index: 3;
    color:black;
    text-shadow: 0 1px 0 #fff;
    
    }*/
    
    #tabs a:focus {
        outline: 0;
    }
    
    #tabs a::after {
        content:'';
        position:absolute;
        z-index: 1;
        top: 0;
        right: -.5em;
        bottom: 0;
        width: 1em;
        background: #ddd;
        /*background-image: linear-gradient(to bottom, #fff, #ddd); */
        // box-shadow: 2px 2px 2px rgba(0,0,0,0);
        transform: skew(10deg);
        border-radius: 0 5px 0 0;
    }
    
    #tabs .current a,
    #tabs .current a::after {
        background: #28ad1f;
        z-index: 3;
        color:#fff;
        /*  background-image: linear-gradient(to bottom, #fff, #2196F3); */
    }
    
    #content {
        background: #323232;
        padding: 2em;
        height: 220px;
        position: relative;
        z-index: 2;
        border-radius: 0 5px 5px 5px;
        box-shadow: 0 -2px 3px -2px rgba(0, 0, 0, 0);
    }
    
    .labelbck{
        background-color: #000000;border:2px solid #000000;height:30px;width:145px;padding:5px;padding-left:20px;font-weight:900;
        border-radius:3px 14px 0px 0px;color:#fff;
    
    }
    .skew{
        background-color: #000000;height:30px;width: 40px;margin-top:-26px;margin-left:105px;
        -webkit-transform: scale(1) skewX(50deg);
    }
    
    .tblemployees tr td {
        background-color: #666666;
        color: #fff;
    }
    
    .tblemployees tr td label{
        font-family: muli;
        font-weight: bold;
    }
    
    </style>
    
    <div id="content2" style="margin-left: -4px; margin-top : 30px; border:0px solid #f0f0f0; width:100%; background-color: #323232; ">
    
        <div>
            <div style="width: 100%;">
                <div class="content-box-large">
                    <div class="panel-title">
                        <ul id="tabs">
                            <li ng-class="current.personal"><a ng-click="change_tab('personal')" style="font-family: muli; font-size: 14px;" name="tab1">Personal Information</a></li>
                            <li ng-class="current.education"><a ng-click="change_tab('education')" style="font-family: muli; font-size: 14px;" name="tab2">Educational Attainment</a></li>
                            <li ng-class="current.company"><a ng-click="change_tab('company')" style="font-family: muli; font-size: 14px;" name="tab3">Employee Profile</a></li>
                            <li ng-class="current.compensation" ng-if="profile.permission.compensation.link"><a ng-click="change_tab('compensation')" style="font-family: muli; font-size: 14px;" name="tab5">Compensation Details</a></li>
                            <li ng-class="current.government"><a ng-click="change_tab('government')" style="font-family: muli; font-size: 14px;" name="tab4">Government & License ID No.</a></li>
                        </ul>
                    </div>
                </div>
            </div>
            <form name="myForm" novalidate>
                <div ng-if="tab.personal">
                    <table class="tblemployees" width="100%">
                    <tr>
                            <td rowspan="6">
                                <label style="display:block; float:left; padding-top:10px; padding-right:10px;font-size:14px">Upload Profile Pic:</label>
                            </td>
                            <td rowspan="6">
                                <div>
                                    <div>
                                        <div>
                                            <table class="table" border="0">
                                                <tbody>
                                                    <tr>
                                                        <td style="background-color:#666666;" >
                                                            <img src="{{employee.profile_picture}}" style="width:200px;"/>
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                        <div style="width:200px; margin-left:10px;">
                                            <!-- Upload progress: -->
                                            <div class="progress" style="">
                                                <div class="progress-bar" role="progressbar" ng-style="{ 'width': uploader.progress + '%' }"></div>
                                        </div>
                                        <div style="margin-top: 20px;">
                                            <span style="font-size:13px; color:#FF2222;">* Only jpg, png files are allowed.</span>
                                            <input type="file"  nv-file-select="" accept=".jpg,.png,.jpeg" uploader="uploader" />
                                            <br/>
                                        </div>
                                            <button type="button" class="btn btn-success btn-s" ng-click="uploader.uploadAll()">
                                                <span class="glyphicon glyphicon-upload"></span> Upload
                                            </button>
                                            <button type="button" class="btn btn-warning btn-s" ng-click="uploader.cancelAll()">
                                                <span class="glyphicon glyphicon-ban-circle"></span> Cancel
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px ; border:0px solid #f0f0f0;">First Name:</label>
                            </td>
                            <td id="css">
                                <input name="firstName" required ng-model="employee.first_name" type="textarea" style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;" tabindex="2"/>
                                <span style="color:red;" ng-show="myForm.firstName.$error.required">First Name is required.</span>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label style="display:block; float:left; padding-top:10px; padding-right:10px ; font-size:15px; width:120px ; border:0px solid #f0f0f0;">Middle Name:</label>
                            </td>
                            <td id="css">
                                <input name="middleName" required ng-model="employee.middle_name" type="textarea" style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;" tabindex="3"/>
                                <span style="color:red;" ng-show="myForm.middleName.$error.required">Middle Name is required.</span>
                            </td>
                        </tr>
                        <tr>
                        <tr>
                            <td>
                                <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px border:0px;">Last Name:</label>
                            </td>
                            <td id="css">
                                <input name="lastName" required ng-model="employee.last_name" type="textarea" style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;" tabindex="4"/>
                                <span style="color:red;" ng-show="myForm.lastName.$error.required">Last Name is required.</span>
                            </td>
                        </tr>
                            <td>
                                <label style="display:block; float:left; padding-top:10px; padding-right:10px;font-size:15px">Birth Date :</label>
                            </td>
                            <td id="css">
                                <input name="bdate" ng-model="employee.birth_date" ng-change="employee.birth_dates = employee.birth_date" type="date" style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;" ng-required="true"/>
                                <span style="color:red;display: block; float: left; width:310px;" ng-show="myForm.bdate.$error.required">Birth Date is required.</span>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label style="display:block; float:left; padding-top:10px; padding-right:10px;font-size:15px">Religion:</label>
                            </td>
                            <td id="css">
                                <input name="religions" required ng-model="employee.religion"  type="textarea" style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;" capitalize-first />
                                <span style="color:red;display: block; float: left; width:310px;" ng-show="myForm.religions.$error.required">Religion is required.</span>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label style="display:block; float:left; padding-top:-10px; padding-right:10px">Gender:</label>
                            </td>
                            <td id="css">
                                <select name="gender" required ng-model="employee.gender" style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px; border:0px solid #f0f0f0;; " >
                                    <option value="" disabled selected style="display:none"> -- Select from the options -- </option>
                                    <option value="Male">Male</option>
                                    <option value="Female">Female</option>
                                </select>
                                <span style="color:red;display: block; float: left; width:310px;" ng-show="myForm.gender.$error.required">Gender is required.</span>
                            </td>
                            <td>
                                <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px ; border:0px solid #f0f0f0;">E-mail Address:</label>
                            </td>
                            <td id="css">
                                <input name="email" required ng-model="employee.email_address" type="email" style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;" tabindex="7"/>
    
                                <span style="color:red" ng-show="myForm.email.$error.required">E-mail Address is required.</span>
                                <span style="color:red" ng-show="myForm.email.$error.email">Please, write a valid E-mail Address address.</span>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                    <label style="display:block; float:left; padding-top:10px; padding-right:10px;font-size:15px">Civil Status:</label>
                                </td>
                                <td id="css">
                                    <select name="cistatus" required ng-model="employee.civilstatus" style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px; border:0px solid #f0f0f0;; " >
                                        <option value="" disabled selected style="display:none"> -- Select from the options -- </option>
                                        <option value="Single">Single</option>
                                        <option value="Married">Married</option>
                                        <option value="Divorced">Divorced</option>
                                        <option value="Living Common Law">Living Common Law</option>
                                        <option value="Widowed">Widowed</option>
                                    </select>
                                    <span style="color:red;display: block; float: left; width:310px;" ng-show="myForm.cistatus.$error.required">Civil Status is required.</span>
                            </td>
                            <td><label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:13px; width:120px ; border:0px solid #f0f0f0;">Name of Spouse:</label>
                            </td>
                            <td id="css">
                                <input name="spouse" required ng-model="employee.spouse" type="textarea" style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;" tabindex="4"/>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label style="display:block; float:left; padding-top:10px; padding-right:10px;font-size:15px">Contact Number:</label>
                            </td>
                            <td id="css">
                                <input name="cnumber" required ng-model="employee.contact_number"  type="textarea" style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;" is-number placeholder="(Optional)" />
                            </td>
                            <td>
                                <label style="display:block; float:left; padding-top:10px; padding-right:10px;font-size:14px">Landline Number:</label>
                            </td>
                            <td id="css">
                                <input name="lnumber" required ng-model="employee.landline_number"  type="textarea" style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;"  is-number placeholder="(Optional)"/>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label style="display:block; float:left; padding-top:10px; padding-right:10px;font-size:15px">Present Address:</label>
                            </td>
                            <td id="css">
                                <textarea name="paddress" required ng-model="employee.present_address"  type="textarea" style="display: block; float: left; width:310px; height:100px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;"  capitalize-first />
                                <span style="color:red;display: block; float: left; width:310px;" ng-show="myForm.paddress.$error.required">Present address is required.</span>
                            </td>
                            <td>
                                <label style="display:block; float:left; padding-top:10px; padding-right:10px;font-size:15px">Permanent <br> Address:</label>
                            </td>
                            <td id="css">
                                <textarea name="pladdress" required ng-model="employee.permanent_address"  type="textarea" style="display: block; float: left; width:310px; height:100px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;"  capitalize-first />
                                <span style="color:red;display: block; float: left; width:310px;" ng-show="myForm.pladdress.$error.required">Permanent address is required.</span>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label style="display:block; float:left; padding-top:10px; padding-right:5px;font-size:12.4px">In case of Emergency who to contact:</label>
                            </td>
                            <td id="css">
                                <input name="ename" tabindex="13" required ng-model="employee.emergency_contact_name"  type="textarea" style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;" placeholder="Contact Person Name" capitalize-first />
                                <span style="color:red;display: block; float: left; width:310px;" ng-show="myForm.ename.$error.required">Contact person is required.</span>
                            </td>
                            <td>
                                <label style="display:block; float:left; padding-top:10px; padding-right:10px;font-size:15px">Contact number:</label>
                            </td>
                            <td id="css">
                                <input name="enumber" tabindex="14" required ng-model="employee.emergency_contact_number"  type="textarea" style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;" placeholder="Contact Person Contact Number" is-number/>
                                <span style="color:red;display: block; float: left; width:310px;" ng-show="myForm.enumber.$error.required">Contact number is required.</span>
                            </td>
                        </tr>
                        <tr>
                                <td>
                                    <label style="display:block; float:left; padding-top:10px; padding-right:10px;font-size:15px">Relationship:</label>
                                </td>
                                <td id="css">
                                    <input name="rmam" tabindex="13" required ng-model="employee.emergency_relationship"  type="textarea" style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;"  placeholder="Contact Persons Relationship" capitalize-first />
                                    <span style="color:red;display: block; float: left; width:310px;" ng-show="myForm.rmam.$error.required">Contact Persons Relationship is required.</span>
                                </td>
                            <td></td>
                            <td></td>
    
                            </tr>
                        <tr>
                            <td>
                                <label style="display:block; float:left; padding-top:10px; padding-right:10px;font-size:15px">Hobbies:</label>
                            </td>
                            <td id="css">
                                <textarea name="phobbies" required ng-model="employee.hobbies"  type="textarea" style="display: block; float: left; width:310px; height:100px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;"  capitalize-first />
                            </td>
                            <td>
                                <label style="display:block; float:left; padding-top:10px; padding-right:10px;font-size:15px">Interest:</label>
                            </td>
                            <td id="css">
                                <textarea name="pinterest" required ng-model="employee.interest"  type="textarea" style="display: block; float: left; width:310px; height:100px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;"  capitalize-first />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label style="display:block; float:left; padding-top:10px; padding-right:10px;font-size:15px">Extra-curricular<br>activities:</label>
                            </td>
                            <td id="css">
                                <textarea name="pextra" required ng-model="employee.extra_curricular"  type="textarea" style="display: block; float: left; width:310px; height:100px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;"  capitalize-first />
                            </td>
                            <td>
                                <label style="display:block; float:left; padding-top:10px; padding-right:10px;font-size:15px">Achievements:</label>
                            </td>
                            <td id="css">
                                <textarea name="pachievements" required ng-model="employee.achievements"  type="textarea" style="display: block; float: left; width:310px; height:100px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;"  capitalize-first />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label style="display:block; float:left; padding-top:10px; padding-right:10px;font-size:15px">Sports:</label>
                            </td>
                            <td id="css">
                                <textarea name="psports" required ng-model="employee.sports"  type="textarea" style="display: block; float: left; width:310px; height:100px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;"  capitalize-first />
                            </td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr>
                            <td colspan = "4">
                                <center style="font-size: 18px; font-style: bold">
                                    <button type="button" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-secondary" data-ng-click="confirm(1)">{{modal.close}}</button>
                                    <button type="submit" class="ngdialog-button ngdialog-button-primary" data-ng-click="closeThisDialog('Save')"  style="background-color: #111111; color: #fff; border-radius: 5px;">{{modal.save}}</button>
    
                                </center>
                            </td>
                        </tr>
                    </table>
                </div>
                <div ng-if="tab.education">
                    <table class="tblemployees" ng-repeat="form in employee.educations track by $index" ng-init="name = form.educ_level
                    " width="100%">
                    <tr>
    
                        <td><h4 style="display:block; float:left;padding-right:10px; font-size:17px; font-family: muli; width:100%; border:0px solid #f0f0f0;" ><div class ="labelbck">{{form.educ_level}}</div></h4></td>
                        <td>
                            <input type="image" src="./ASSETS/img/delete_with_circle.png" ng-click="removeChoice($index)" title="Remove Education" style="width:36px; height:40px; padding-top:6px;">
                        </td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td>
                            <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px  ; border:0px solid #f0f0f0;">School Name:</label>
                        </td>
                        <td id="css">
                            <input name="snschool" required ng-model="form.school_name" type = "textarea"  style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;" />
                        </td>
                        <td>
                            <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:14px; width:120px ; border:0px solid #f0f0f0;"> School Location:</label>
                        </td>
                        <td id="css">
                            <input name="slschool" required ng-model="form.school_location" type = "textarea" style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <label style="display:block; float:left; padding-top:10px; padding-right:10px;font-size:15px">From Year:</label>
                        </td>
                        <td id="css">
                            <select ng-model="form.year_from" type="date" id="datefrom" style="display: block; float: left; width:310px; height:33px;">
                                <option value="" disabled selected style="display:none"> -- Select from the options -- </option>
                                <option ng-repeat="v in year_dates" style="cursor:pointer;" value="{{v.year}}">
                                    {{v.year}}
                                </option>
                            </select>
                        </td>
                        <td>
                            <label style="display:block; float:left; padding-top:10px; padding-right:10px;font-size:15px">To Year:</label>
                        </td>
                        <td id="css">
                            <select ng-model="form.year_to" type="date" id="dateto" style="display: block; float: left; width:310px; height:33px;">
                                <option value="" disabled selected style="display:none"> -- Select from the options -- </option>
                                <option ng-repeat="v in year_dates" style="cursor:pointer;" value="{{v.year}}">
                                    {{v.year}}
                                </option>
                            </select>
                        </td>
                    </tr>
                </table>
                <table class="tblemployees" width="100%">
                    <tr>
                        <td>
                           <select ng-model="employee.school_type" style="display: block; float: right; width:290px;padding:5px;" >
                                <option value="" disabled selected style="display:none"> -- Select from the options -- </option>
    
                                <option ng-repeat="(k,v) in educ_ile.data" value="{{v.levels}}">{{v.levels}}</option>

                            </select>
                        </td>
                        <td>
                            <button type="button" ng-click="addNewChoice()" class="large button white" style="display: block; float: left; width:150px; height:25px;font-size:15px" >+ Add Education</button>
                        </td>
                        <td></td>
                    </tr>
                    <tr>
                        <td colspan = "3"
                            <center style="font-size: 18px; font-style: bold">
                                <button type="button" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-secondary" data-ng-click="confirm(1)">{{modal.close}}</button>
                                <button type="submit" class="ngdialog-button ngdialog-button-primary" data-ng-click="closeThisDialog('Save')" style="background-color: #111111; color: #fff; border-radius: 5px;">{{modal.save}}</button>
    
                            </center>
                        </td>
                    </tr>
    
                </table>
            </div>
    
          
            </table>
            
        </div>

        <div ng-if="tab.company">
            <table class="tblemployees" width="100%">
                <tr>
                    <td>
                        <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:14px; width:120px  ; border:0px solid #f0f0f0;">Company Name:</label>
                    </td>
                    <td id="css">
                        <input name="ciiname" required ng-model = "employee.company_name" type = "textarea" style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;" disabled tabindex="1"/>
                        <span style="color:red" ng-show="myForm.ciiname.$error.required">Company Name is required.
                        </span>
                    </td>
                 <td>
                            <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:14px; width:120px;  border:0px solid #f0f0f0;">Employee ID:</label>
                        </td>
                        <td id="css">
                            <input name="ciiname" type = "text" style="display: block; float:left;  width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;"tabindex="1" ng-model="employee.old_id"/>
 
                        </td>
                      </tr>
                 <tr>
                  <td>
                      <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:14px; width:120px  ; border:0px solid #f0f0f0;">Sub-Company<br>Name:</label></td>
                    <td><select name="subcompanyname" required ng-model="employee.subcompany" style="display: block; float: left; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px; border:0px; solid #f0f0f0;  margin-right: 10px; width:310px;" >
                        <option value="" disabled selected style="display:none"> -- Select from the options -- </option>
                        <option ng-repeat="(k, v) in subcompany.data" style="cursor:pointer;" value="{{v.name}}">
                            {{v.name}}
                        </option>
                    </select>
                    <span style="color:red;display: block; float: left; width:310px;" ng-show="myForm.subcompanyname.$error.required">Sub-Company is required.</span></td></td>
                    
                    <td><label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:14px; width:120px  ; border:0px solid #f0f0f0;">Branch</label></td>
 
                  
                    <td><select name="branchname" required ng-model="employee.branch" style="display: block; float: left; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px; border:0px; solid #f0f0f0;  margin-right: 10px; width:310px;" >
                        <option value="" disabled selected style="display:none"> -- Select from the options -- </option>
                        <option ng-repeat="(k, v) in branch.data" style="cursor:pointer;" value="{{v.name}}">
                            {{v.name}}
                        </option>
                    </select>
                    <span style="color:red;display: block; float: left; width:310px;" ng-show="myForm.branchname.$error.required">Branch is required.</span></td>
             
                </tr>
                <tr>
                    <td>
                        <label style="display:block; float:left; padding-top:10px; padding-right:10px;font-size:14px">With <br>Contract:</label>
                    </td>
                    <td id="css">
                        <input name="checkbox" required ng-model="employee.contract_yes" value="1" type = "radio" style="display: block; float: left; width:50px; height:38px;"/>
                    </td>
                     <td>
                        <label style="display:block; float:left; padding-top:10px; padding-right:10px;font-size:14px">Without <br>Contract:</label>
                    </td>
                    <td id="css">
                        <input name="checkbox" required ng-model="employee.contract_yes" value="2" type = "radio" style="display: block; float: left; width:50px; height:38px;"/>
                    </td>
                </tr>
                <tr>
                    <td>
                        <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px  ; border:0px solid #f0f0f0;">Pandas User <br>ID:</label>
                    </td>
                    <td id="css">
                        <input name="user" required ng-model = "employee.employee_id" maxlength = "20"type = "textarea" style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;" tabindex="1"/>
                        <span style="color:red" ng-show="myForm.user.$error.required">Employee ID is required.</span>
                    </span>
                </td>
                <td>
                    <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:14px; width:120px; border:0px solid #f0f0f0;"> Business E-mail Address:</label>
                </td>
                <td id="css">
                    <input name="businessEmail" required ng-model="employee.business_email_address" type="email" style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;" tabindex="6"/>

                    <span style="color:red" ng-show="myForm.businessEmail.$error.required">Business E-mail Address is required.</span>
                    <span style="color:red" ng-show="myForm.businessEmail.$error.email">Please, write a valid Business E-mail Address address.</span>
                </td>
            </tr>

            <tr>
                <td>
                    <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px border:0px;">Department:</label>
                </td>

                <td id="css">
                    <select required ng-model="employee.departments_pk" style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px; ;border:0px solid #f0f0f0;; " tabindex="8">
                        <!-- <option style="display:none">-- Please Select One --</option> -->
                        <option ng-repeat="(k, v) in department.data" style="cursor:pointer;" value="{{v.pk}}">

                            {{v.department}}

                        </option>

                    </select>

                </td>
                <td>
                    <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:14px; width:120px; border:0px;">Employee <br>Status:</label>
                </td>
                <td id="css">
                    <select name="employeet" required ng-model="employee.employee_status" style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px; border:0px solid #f0f0f0; " >
                        <option value="" disabled selected style="display:none"> -- Select from the options -- </option>
                        <option ng-repeat="(k, v) in employee_status.data" style="cursor:pointer;" value="{{v.pk}}">
                            {{v.status}}
                        </option>
                    </select>
                    <input type="textarea" placeholder = 'no. of hours' is-number maxlength = "3" size = "10" ng-model = "employee.intern_hours"  ng-show="employee.employee_status == '6'" required/ style="height: 40px;color: black">
                    <span style="color:red;display: block; float: left; width:310px;" ng-show="myForm.employeet.$error.required">Employee status is required.</span>
                </td>
            </tr>
            <tr>
                <td>
                    <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px; border:0px;">Level:</label>
                </td>

                <td id="css">
                    <select required ng-model="employee.levels_pk" style="display: block; float: left; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px; border:0px; solid #f0f0f0;  margin-right: 10px;" tabindex="9" ng-change = "level_changed()" ng-class = "level_class">
                        <option ng-repeat="(k, v) in level_title.data" style="cursor:pointer;" value="{{v.pk}}" >
                            {{v.level_title}}
                        </option>
                    </select>
                </td>

                <td>
                    <label style="display:block; float:left; padding-top:10px; padding-right:10px;font-size:14px">Employment <br>Type:</label>
                </td>
                <td id="css">
                    <select name="employmenttype" required ng-model="employee.employment_types" style="display: block; float: left; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px; border:0px; solid #f0f0f0;  margin-right: 10px; width:310px;" >
                        <option value="" disabled selected style="display:none"> -- Select from the options -- </option>
                        <option ng-repeat="(k, v) in employment_type.data" style="cursor:pointer;" value="{{v.pk}}">
                            {{v.type}}
                        </option>
                    </select>
                    <span style="color:red;display: block; float: left; width:310px;" ng-show="myForm.employmenttype.$error.required">Employment type is required.</span>

                </td>
            </tr>
            <tr>    
                <td>
                    <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px; border:0px;">Team:</label>
                </td>

                <td id="css">
                    <select required ng-model="employee.teams_pk" style="display: block; float: left; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px; border:0px; solid #f0f0f0;  margin-right: 10px;" tabindex="9" ng-change = "" ng-class = "level_class">
                        <option ng-repeat="(k, v) in team_title.data" style="cursor:pointer;" value="{{v.pk}}" >
                            {{v.team_name}}
                        </option>
                    </select>
                </td>
                <td colspan = 2></td>
            </tr>
            <tr>
                <td>
                    <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px; border:0px;">Position:</label>
                </td>
                <td id="css">
                    <select required ng-model="employee.titless" style="display: block; float: left; width:310px;  height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;border:0px solid #f0f0f0;; " tabindex="5">
                        <!-- <option style="display:none">-- Please Select One --</option> -->
                        <option ng-repeat="(k, v) in titles.data" style="cursor:pointer;" value="{{v.pk}}">
                            {{v.title}}
                        </option>
                    </select>
                </td>
                <td>
                    <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px; border:0px;">Immediate Superior:</label>
                </td>
                <td id="css">
                    <select required ng-model="employee.supervisor_pk" style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px; border:0px solid #f0f0f0;; " tabindex="5">
                        <!-- <option style="display:none">-- Please Select One --</option> -->
                        <option ng-repeat="(k, v) in employees.supervisors" style="cursor:pointer;" value="{{v.pk}}">
                            {{v.name}}
                        </option>
                    </select>
                </td>
                <tr>
                    <tr>
                        <td>
                            <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px; border:0px;">Start Date:</label>
    
                        </td>
                        <td id="css">
                            <input name="inputd" ng-model="employee.date_started" type="date"  style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;" ng-required="true" />
                            <span style="color:red;display: block; float: left; width:310px;" ng-show="myForm.inputd.$error.required">Start Date is required.</span>
                        </td>
                        <td>
                            <label ng-show="show_regular" style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px border:0px;">Regularization <br>Date:</label>
    
                        </td>

                        <td id="css">
                            <input ng-show="show_regular" name="inputk" ng-model="employee.regularization_date" type="date"  style="display: block; float: left; width:150px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;"/>


                            <button type="button" ng-show="show_regular" ng-click="email_reminder(employee)" style="border-radius: 10px; margin-left:10px; background-color:black ; width: 150px; height: 50px" >
                                    <span class="glyphicon glyphicon-envelope"></span> Set Email <br>Reminder
                            </button>

                        </td>
                            

                         <tr>
                            <td>
                                <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px border:0px;">Payroll Type:</label>
                            </td>
                            <td>
                                <input type="radio" id="4" name="salarys" ng-model="employee.salary_type" value="4"> None</input>
                                <input type="radio" id="1" name="salarys" ng-model="employee.salary_type" value="1"> Bank</input>
                                <input type="radio" id="3" name="salarys" ng-model="employee.salary_type" value="3"> Wire Transfer</input>
                                <input type="radio" id="2" name="salarys" ng-model="employee.salary_type" value="2"> Cash</input>
                            </td>
                            <td>
                                <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px border:0px;">No Statutory Benefit:</label></td>
                            <td>
                                <input  ng-model="employee.benefit_suspension" title="Please check this box if you want to suspend his benefits" type="checkbox" style="display: block; float: left; width: 40px; height:40px;"/>
                            </td>
                        </tr>

                    </tr>
                    <tr ng-show="isShown('1')">
                        <td>
                            <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px border:0px;">Bank Name:</label>
                        </td>
                        <td id="css">
                            <input name="bname" required ng-model="employee.bank_name" type = "text"  style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;" />
                            <span style="color:red;display: block; float: left; width:310px;" ng-show="myForm.bname.$error.required">Bank Name is required.</span>
                        </td>
                        <td>
                            <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px border:0px;">Account<br> Number:</label>
                        </td>
                        <td id="css">
                            <input name="anames" required ng-model="employee.account_number" type = "text" is-number style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;" />
                            <span style="color:red;display: block; float: left; width:310px;" ng-show="myForm.anames.$error.required">Account Number is required.</span>
                        </td>
                    </tr>
                    <tr ng-show="isShown('1')">
                        <td>
                            <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px border:0px;">Salary Type:</label>
                        </td>
                        <td id="css">
                            <select name="ratype" required ng-model="employee.rate_type" style="display: block; float: left; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px; border:0px; solid #f0f0f0;  margin-right: 10px; width:310px;" >
                                <option value="" disabled selected style="display:none"> -- Select from the options -- </option>
                                <option ng-repeat="(k, v) in rate_type.data" style="cursor:pointer;" value="{{v.pk}}">
                                    {{v.type}}
                                </option>
                            </select>
                            <span style="color:red;display: block; float: left; width:310px;" ng-show="myForm.ratype.$error.required">Salary Type is required.</span>
                        </td>
                        <td>
                            <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px border:0px;">Pay Period:</label>
                        </td>
                        <td id="css">
                            <select name="ptype" required ng-model="employee.pay_period" style="display: block; float: left; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px; border:0px; solid #f0f0f0;  margin-right: 10px; width:310px;" >
                                <option value="" disabled selected style="display:none"> -- Select from the options -- </option>
                                <option ng-repeat="(k, v) in pay_period.data" style="cursor:pointer;" value="{{v.pk}}">
                                    {{v.period}}
                                </option>
                            </select>
                            <span style="color:red;display: block; float: left; width:310px;" ng-show="myForm.ptype.$error.required">Pay Period is required.</span>
                        </td>
                        <!-- <td>
                            <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px border:0px;">Amount:</label>
                        </td>
                        <td id="css">
                            <input name="a_mount" required ng-model="employee.amount" type = "text" is-number style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;" />
                            <span style="color:red;display: block; float: left; width:310px;" ng-show="myForm.a_mount.$error.required">Amount is required.</span>
                        </td> -->
                    </tr>
                    <!-- <tr ng-show="isShown('1')">
                        <td>
                            <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px border:0px;">Pay Period:</label>
                        </td>
                        <td id="css">
                            <select name="ptype" required ng-model="employee.pay_period" style="display: block; float: left; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px; border:0px; solid #f0f0f0;  margin-right: 10px; width:310px;" >
                                <option value="" disabled selected style="display:none"> -- Select from the options -- </option>
                                <option ng-repeat="(k, v) in pay_period.data" style="cursor:pointer;" value="{{v.pk}}">
                                    {{v.period}}
                                </option>
                            </select>
                            <span style="color:red;display: block; float: left; width:310px;" ng-show="myForm.ptype.$error.required">Pay Period is required.</span>
                        </td>
                        <td></td>
                        <td></td>
                    </tr> -->
                    <tr ng-show="isShown('1')">
                        <td>
                            <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; border:0px;">With <br>Allowances:</label>
                        </td>
                       <td id="css">
                            <input  ng-model="employee.allowances_status" title="Please check this box if you want to put an allowances"type="checkbox" style="display: block; float: left; width: 40px; height:40px;"/>
                        </td>
                        <td></td>
                        <td></td>
                    </tr>
                     <tr ng-show="isShown('1') && employee.allowances_status">
                        <td>
                            <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px border:0px;">Allowance <br>Type:</label>
                        </td>
                        <td id="css">
                            <select ng-model="allowance_types" style="display: block; float: left; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px; border:0px; solid #f0f0f0;  margin-right: 10px; width:310px;" >
                                <option value="" disabled selected style="display:none"> -- Select from the options -- </option>
                                <option ng-repeat="(k, v) in allowance_type.data" style="cursor:pointer;" value="{{v.type}}">
                                    {{v.type}}
                                </option>
                            </select>
                        </td>
                        <td>
                            <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px border:0px;">Alloted Amount Per Month:</label>
                        </td>
                        <td id="css">
                            <input ng-model="allowance_amount" type = "text" is-number style="display: block; float: left; width:100px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;" required/>
                            &nbsp
                            <button type="button" ng-click="add_allowances()" class="large button white" style="width:200px;">+ Add Allowance</button>
                        </td>
                    </tr>
                    </table>
                    <table class="tblemployees table table-bordered table-striped" ng-show="isShown('1') && employee.allowances_status" style="margin-top:-10px; width;100%;" >
                        <thead>
                            <tr>
                                <th>Allowance Type</th>
                                <th>Alloted Amount Per Month:</th>
                                <th>Option</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr ng-repeat="allow in employee.allowances">
                                <td>{{allow.allowance_types}}</td>
                                <td>{{allow.allowance_amount}}</td>
                                <td><button ng-click="del_allowances($index)" style="background-color:#323232; color#fff;"><b>Delete</b></button></td>
                            </tr>
                        </tbody>
                    </table>
                    
                    <table class="tblemployees" ng-show="isShown('1') && employee.dependents_status" width="100%">
                        <tr>
                            <td>
                                <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px border:0px;">Dependent <br>Full Name:</label>
                            </td>
                            <td id="css">
                                <input ng-model="dependent_full_name" type="textarea" style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;"/>
                            </td>
                            <td>
                                <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px border:0px;">Relationship:</label>
                            </td>
                            <td id="css">
                                <input ng-model="dependent_relationship" type="textarea" style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px border:0px;">Birthdate:</label>
                            </td>
                            <td id="css">
                                <input ng-model="dependent_birth_date" type="date" style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;"/>
                            </td>
                            <td>
                                <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px border:0px;">Supporting <br>Document:</label>
                            </td>
                            <td>
                                <input type="file" nv-file-select="" uploader="uploader_dependent"/>
                                <button type="button" class="btn btn-success btn-s" ng-click="uploader_dependent.uploadAll()">
                                <span class="glyphicon glyphicon-upload"></span> Upload
                                </button>
                                <button type="button" tabindex="17" class="btn btn-warning btn-s" ng-click="uploader_dependent.cancelAll()">
                                <span class="glyphicon glyphicon-ban-circle"></span> Cancel</button>
                                <div class="progress" style="">
                                <div class="progress-bar" role="progressbar" ng-style="{ 'width': uploader_dependent.progress + '%' }"></div>
                                                                </div>
    
                            </td>
    
                        </tr>
    
                    </table>
                     <table class="tblemployees" ng-show="isShown('1') && employee.dependents_status" width="100%" style="margin-top:-10px;">
                        <tr>
                        <td colspan="3">
                        <td>
                         <button type="button" ng-click="add_dependent()" class="large button white" style="width:170px;margin-top:-30px;">+ Add Dependent</button>
                        </td>
    
                        </tr>
                    </table>
                    <table ng-show="isShown('1') && employee.dependents_status" style="margin-top:-10px;"class="table table-bordered table-striped table-hover" width="100%">
                        <thead>
                            <tr>
                                <th style="font-size:15px">Dependent Full Name</th>
                                <th style="font-size:15px">Relationship</th>
                                <th style="font-size:15px">Birthdate</th>
                                <th style="font-size:15px">Supporting Document</th>
                                <th style="font-size:15px">Option</th>
                            </tr>
                        </thead>
                        <tbody width="100%">
    
                            <tr ng-repeat="allows in employee.dependents track by $index">
                                <td>{{allows.dependent_full_name}}</td>
                                <td>{{allows.dependent_relationship}}</td>
                                <td>{{allows.dependent_birth_date | date:'MM/dd/yyyy'}}</td>
                                <td>{{allows.dependent_supporting_document}}</td>
                                <td><button ng-click="del_dependent($index)" style="background-color:#323232; color:#fff;"><b>Delete</b></button></td>
                            </tr>
                        </tbody>
                    </table>
                    <table class="tblemployees" width="100%">
                    <tr ng-show="isShown('3')">
                        <td>
                            <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px border:0px;">Mode of <br>Payment:</label>
                        </td>
                        <td id="css">
                            <input name="mpayment" required ng-model="employee.salary_mode_payment" type = "text"  style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;" />
                            <span style="color:red;display: block; float: left; width:310px;" ng-show="myForm.mpayment.$error.required">Mode of payment is required.</span>
                        </td>
                        <td>
                            <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px border:0px;">Account <br>Number:</label>
                        </td>
                        <td id="css">
                            <input name="aname" required ng-model="employee.account_number" type = "textarea" is-number style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;" />
                            <span style="color:red;display: block; float: left; width:310px;" ng-show="myForm.aname.$error.required">Account Number is required.</span>
                        </td>
    
                    </tr>
                    <tr ng-show="isShown('3')">
                        <td>
                            <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px border:0px;">Salary Type:</label>
                        </td>
                        <td id="css">
                            <select name="ratype" required ng-model="employee.rate_type" style="display: block; float: left; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px; border:0px; solid #f0f0f0;  margin-right: 10px; width:310px;" >
                                <option value="" disabled selected style="display:none"> -- Select from the options -- </option>
                                <option ng-repeat="(k, v) in rate_type.data" style="cursor:pointer;" value="{{v.pk}}">
                                    {{v.type}}
                                </option>
                            </select>
                            <span style="color:red;display: block; float: left; width:310px;" ng-show="myForm.ratype.$error.required">Salary Type is required.</span>
                        </td>
                        <td>
                            <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px border:0px;">Pay Period:</label>
                        </td>
                        <td id="css">
                            <select name="ptype" required ng-model="employee.pay_period" style="display: block; float: left; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px; border:0px; solid #f0f0f0;  margin-right: 10px; width:310px;" >
                                <option value="" disabled selected style="display:none"> -- Select from the options -- </option>
                                <option ng-repeat="(k, v) in pay_period.data" style="cursor:pointer;" value="{{v.pk}}">
                                    {{v.period}}
                                </option>
                            </select>
                            <span style="color:red;display: block; float: left; width:310px;" ng-show="myForm.ptype.$error.required">Pay Period is required.</span>
                        </td>
                        <!-- <td>
                            <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px border:0px;">Amount:</label>
                        </td>
                        <td id="css">
                            <input name="a_mount" required ng-model="employee.amount" type = "textarea" is-number style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;" />
                            <span style="color:red;display: block; float: left; width:310px;" ng-show="myForm.a_mount.$error.required">Amount is required.</span>
                        </td>  -->
                    </tr>
                    <!-- <tr ng-show="isShown('3')">
                        <td>
                            <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px border:0px;">Pay Period:</label>
                        </td>
                        <td id="css">
                            <select name="ptype" required ng-model="employee.pay_period" style="display: block; float: left; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px; border:0px; solid #f0f0f0;  margin-right: 10px; width:310px;" >
                                <option value="" disabled selected style="display:none"> -- Select from the options -- </option>
                                <option ng-repeat="(k, v) in pay_period.data" style="cursor:pointer;" value="{{v.pk}}">
                                    {{v.period}}
                                </option>
                            </select>
                            <span style="color:red;display: block; float: left; width:310px;" ng-show="myForm.ptype.$error.required">Pay Period is required.</span>
                        </td>
                        <td colspan="2"></td>
                    </tr> -->
                    <tr ng-show="isShown('3')">
                        <td>
                            <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; border:0px;">With <br>Allowances:</label>
                        </td>
                       <td id="css">
                            <input ng-model="employee.allowances_status" title="Please check this box if you want to put an allowances"type="checkbox" style="display: block; float: left; width: 40px; height:40px; "/>
                        </td>
                        <td colspan="2"></td>
                    </tr>
                    <tr ng-show="isShown('3') && employee.allowances_status">
                        <td>
                            <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px border:0px;">Allowance Type:</label>
                        </td>
                        <td id="css">
                            <select ng-model="allowance_types" style="display: block; float: left; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px; border:0px; solid #f0f0f0;  margin-right: 10px; width:310px;" >
                                <option value="" disabled selected style="display:none"> -- Select from the options -- </option>
                                <option ng-repeat="(k, v) in allowance_type.data" style="cursor:pointer;" value="{{v.type}}">
                                    {{v.type}}
                                </option>
                            </select>
                        </td>
                        <td>
                            <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px border:0px;">Alloted Amount Per Month:</label>
                        </td>
                        <td id="css">
                            <input ng-model="allowance_amount" type = "textarea" is-number style="display: block; float: left; width:100px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;" required/>
                            &nbsp
                            <button type="button" ng-click="add_allowances()" class="large button white" style="width:200px;">+ Add Allowance</button>
                        </td>
                    </tr>
                    </table>
                    <table class="tblemployees table table-bordered table-striped" ng-show="isShown('3') && employee.allowances_status" style="margin-top:-10px;" width="100%">
                        <thead>
                            <tr>
                                <th style="font-size:15px">Allowance Type</th>
                                <th style="font-size:15px">Alloted Amount Per Month:</th>
                                <th style="font-size:15px">Option</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr ng-repeat="allow in employee.allowances track by $index">
                                <td>{{allow.allowance_types}}</td>
                                <td>{{allow.allowance_amount}}</td>
                                <td><button ng-click="del_allowances($index)" style="background-color:#323232; color:#fff;"><b>Delete</b></button></td>
                            </tr>
                        </tbody>
                    </table>
                    
                    <table class="tblemployees" ng-show="isShown('3') && employee.dependents_status" width="100%">
                        <tr>
                            <td>
                                <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px border:0px;">Dependent <br>Full Name:</label>
                            </td>
                            <td id="css">
                                <input ng-model="dependent_full_name" type="textarea" style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;"/>
                            </td>
                            <td>
                                <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px border:0px;">Relationship:</label>
                            </td>
                            <td id="css">
                                <input ng-model="dependent_relationship" type="textarea" style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px border:0px;">Birthdate:</label>
                            </td>
                            <td id="css">
                                <input ng-model="dependent_birth_date" type="date" style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;"/>
                            </td>
                            <td>
                                <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px border:0px;">Supporting <br>Document:</label>
                            </td>
                            <td>
                                <input type="file" nv-file-select="" uploader="uploader_dependent"/>
                                <button type="button" class="btn btn-success btn-s" ng-click="uploader_dependent.uploadAll()">
                                <span class="glyphicon glyphicon-upload"></span> Upload
                                </button>
                                <button type="button" tabindex="17" class="btn btn-warning btn-s" ng-click="uploader_dependent.cancelAll()">
                                <span class="glyphicon glyphicon-ban-circle"></span> Cancel</button>
                                <div class="progress" style="">
                                <div class="progress-bar" role="progressbar" ng-style="{ 'width': uploader_dependent.progress + '%' }"></div>
                                                                </div>
    
                            </td>
    
                        </tr>
    
                    </table>
                     <table class="tblemployees" ng-show="isShown('3') && employee.dependents_status" width="100%" style="margin-top:-10px;">
                        <tr>
                        <td colspan="3">
                        <td>
                         <button type="button" ng-click="add_dependent(); add_dependents()" class="large button white" style="width:170px;margin-top:-30px;">+ Add Dependent</button>
                        </td>
    
                        </tr>
                    </table>
                    <table ng-show="isShown('3') && employee.dependents_status" style="margin-top:-10px;"class="table table-bordered table-striped table-hover" width="100%">
                        <thead>
                            <tr>
                                <th style="font-size:15px">Dependent Full Name</th>
                                <th style="font-size:15px">Relationship</th>
                                <th style="font-size:15px">Birthdate</th>
                                <th style="font-size:15px">Supporting Document</th>
                                <th style="font-size:15px">Option</th>
                            </tr>
                        </thead>
                        <tbody width="100%">
    
    
                            <tr ng-repeat="allows in employee.dependents track by $index">
                                <td>{{allows.dependent_full_name}}</td>
                                <td>{{allows.dependent_relationship}}</td>
                                <td>{{allows.dependent_birth_date | date:'MM/dd/yyyy'}}</td>
                                <td>{{allows.dependent_supporting_document}}</td>
                                <td><button ng-click="del_dependent($index)"><b>Delete</b></button></td>
                            </tr>
                        </tbody>
                    </table>
                    <table class="tblemployees" style="width: 100%">
                    <tr ng-show="isShown('2')">
                        <td>
                            <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px border:0px;">Salary Type:</label>
                        </td>
                        <td id="css">
                            <select name="ratype" required ng-model="employee.rate_type" style="display: block; float: left; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px; border:0px; solid #f0f0f0;  margin-right: 10px; width:310px;">
                                <option value="" disabled selected style="display:none"> -- Select from the options -- </option>
                                <option ng-repeat="(k, v) in rate_type.data" style="cursor:pointer;" value="{{v.pk}}">
                                    {{v.type}}
                                </option>
                            </select>
                            <span style="color:red;display: block; float: left; width:310px;" ng-show="myForm.ratype.$error.required">Salary Type is required.</span>
                        </td>
                        <td>
                            <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px border:0px;">Pay Period:</label>
                        </td>
                        <td id="css">
                            <select name="ptype" required ng-model="employee.pay_period" style="display: block; float: left; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px; border:0px; solid #f0f0f0;  margin-right: 10px; width:310px;" >
                                <option value="" disabled selected style="display:none"> -- Select from the options -- </option>
                                <option ng-repeat="(k, v) in pay_period.data" style="cursor:pointer;" value="{{v.pk}}">
                                    {{v.period}}
                                </option>
                            </select>
                            <span style="color:red;display: block; float: left; width:310px;" ng-show="myForm.ptype.$error.required">Pay Period is required.</span>
                        </td>
                        <!-- <td>
                            <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px border:0px;">Amount:</label>
                        </td>
                        <td id="css">
                            <input name="a_mount" required ng-model="employee.amount" type = "textarea" is-number style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;" />
                            <span style="color:red;display: block; float: left; width:310px;" ng-show="myForm.a_mount.$error.required">Amount is required.</span>
                        </td>  -->
                    </tr>
                    <!-- <tr ng-show="isShown('2')">
                        <td>
                            <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px border:0px;">Pay Period:</label>
                        </td>
                        <td id="css">
                            <select name="ptype" required ng-model="employee.pay_period" style="display: block; float: left; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px; border:0px; solid #f0f0f0;  margin-right: 10px; width:310px;" >
                                <option value="" disabled selected style="display:none"> -- Select from the options -- </option>
                                <option ng-repeat="(k, v) in pay_period.data" style="cursor:pointer;" value="{{v.pk}}">
                                    {{v.period}}
                                </option>
                            </select>
                            <span style="color:red;display: block; float: left; width:310px;" ng-show="myForm.ptype.$error.required">Pay Period is required.</span>
                        </td>
                        <td></td>
                        <td></td>
                    </tr> -->
                    <tr ng-show="isShown('2')">
                        <td>
                            <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; border:0px;">With <br>Allowances:</label>
                        </td>
                       <td id="css">
                            <input  ng-model="employee.allowances_status" title="Please check this box if you want to put an allowances"type="checkbox" style="display: block; float: left; width: 40px; height:40px;"/>
                        </td>
                        <td></td>
                        <td></td>
    
                    </tr>
                    <tr ng-show="isShown('2') && employee.allowances_status">
                        <td>
                            <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px border:0px;">Allowance Type:</label>
                        </td>
                        <td id="css">
                            <select ng-model="allowance_types" style="display: block; float: left; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px; border:0px; solid #f0f0f0;  margin-right: 10px; width:310px;" >
                                <option value="" disabled selected style="display:none"> -- Select from the options -- </option>
                                <option ng-repeat="(k, v) in allowance_type.data" style="cursor:pointer;" value="{{v.type}}">
                                    {{v.type}}
                                </option>
                            </select>
                        </td>
                        <td>
                            <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px border:0px;">Alloted Amount Per Month:</label>
                        </td>
                        <td id="css">
                            <input ng-model="allowance_amount" type = "text" is-number style="display: block; float: left; width:100px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;" required/>
                            &nbsp
                            <button type="button" ng-click="add_allowances()" class="large button white" style="width:200px;">+ Add Allowance</button>
                        </td>
                    </tr>
                </table>
                    <table class="tblemployees table table-bordered table-striped" ng-show="isShown('2') && employee.allowances_status" style="margin-top:-10px;" width="100%">
                        <thead>
                            <tr>
                                <th style="font-size:15px">Allowance Type</th>
                                <th style="font-size:15px">Alloted Amount Per Month:</th>
                                <th style="font-size:15px">Option</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr ng-repeat="allow in employee.allowances track by $index">
                                <td>{{allow.allowance_types}}</td>
                                <td>{{allow.allowance_amount}}</td>
                                <td><button ng-click="del_allowances($index)" style-"background-color:#323232; color:#fff;"><b>Delete</b></button></td>
                            </tr>
                        </tbody>
                    </table>
                    
                    
                    <table class="tblemployees" ng-show="isShown('2') && employee.dependents_status" width="100%">
                        <tr>
                            <td>
                                <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px border:0px;">Tax Status:</label>
                                <select name="tax" required ng-model="employee.tax_status" style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px; border:0px solid #f0f0f0;; " >
                                    <option value="" disabled selected style="display:none"> -- Select from the options -- </option>
                                    <option value="Single">Single</option>
                                    <option value="Married">Married</option>
                                    <option value="S1">Single with 1 Dependent</option>
                                    <option value="S2">Single with 2 Dependents</option>
                                    <option value="S3">Single with 3 Dependents</option>
                                    <option value="S4">Single with 4 Dependents</option>
                                    <option value="M1">Married with 1 Dependent</option>
                                    <option value="M2">Married with 2 Dependents</option>
                                    <option value="M3">Married with 3 Dependents</option>
                                    <option value="M4">Married with 4 Dependents</option>
                                </select>
                            </td>
                        </tr>
                    </table>
                    <table class="tblemployees" ng-show="isShown('2') && (employee.tax_status == 'S1' || employee.tax_status == 'S2' || employee.tax_status == 'S3' || employee.tax_status == 'S4' || employee.tax_status == 'M1' || employee.tax_status == 'M2' || employee.tax_status == 'M3' || employee.tax_status == 'M4')" width="100%">
                        <tr>
                            <td>
                                <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px border:0px;">Dependent <br>Full Name:</label>
                            </td>
                            <td id="css">
                                <input ng-model="dependent_full_name" type="textarea" style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;"/>
                            </td>
                            <td>
                                <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px border:0px;">Relationship:</label>
                            </td>
                            <td id="css">
                                <input ng-model="dependent_relationship" type="textarea" style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px border:0px;">Birthdate:</label>
                            </td>
                            <td id="css">
                                <input ng-model="dependent_birth_date" type="date" style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;"/>
                            </td>
                            <td>
                                <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px border:0px;">Supporting <br>Document:</label>
                            </td>
                            <td>     <br>
                                <input type="file" nv-file-select="" uploader="uploader_dependent"/>
                                <button type="button" class="btn btn-success btn-s" ng-click="uploader_dependent.uploadAll()">
                                <span class="glyphicon glyphicon-upload"></span> Upload
                                </button>
                                <button type="button" tabindex="17" class="btn btn-warning btn-s" ng-click="uploader_dependent.cancelAll()">
                                <span class="glyphicon glyphicon-ban-circle"></span> Cancel</button>
                                <div class="progress" style="">
                                    <div class="progress-bar" role="progressbar" ng-style="{ 'width': uploader_dependent.progress + '%' }"></div>
                                </div>
    
                            </td>
    
                        </tr>
    
                    </table>
                     <table class="tblemployees" ng-show="isShown('2') && (employee.tax_status == 'S1' || employee.tax_status == 'S2' || employee.tax_status == 'S3' || employee.tax_status == 'S4' || employee.tax_status == 'M1' || employee.tax_status == 'M2' || employee.tax_status == 'M3' || employee.tax_status == 'M4')" width="100%" style="margin-top:-10px;">
                        <tr>
                        <td colspan="3">
                        <td>
                         <button type="button" ng-click="add_dependent(); add_dependents()" class="large button white" style="width:170px;margin-top:-30px;">+ Add Dependent</button>
                        </td>
    
                        </tr>
                    </table>
                    <table ng-show="isShown('2') && (employee.tax_status == 'S1' || employee.tax_status == 'S2' || employee.tax_status == 'S3' || employee.tax_status == 'S4' || employee.tax_status == 'M1' || employee.tax_status == 'M2' || employee.tax_status == 'M3' || employee.tax_status == 'M4')" style="margin-top:-10px;" class="table table-bordered table-striped table-hover">
                        <thead>
                            <tr>
                                <th style="font-size:15px">Dependent Full Name</th>
                                <th style="font-size:15px">Relationship</th>
                                <th style="font-size:15px">Birthdate</th>
                                <th style="font-size:15px">Supporting Document</th>
                                <th style="font-size:15px">Option</th>
                            </tr>
                        </thead>
                        <tbody width="100%">
    
    
                            <tr ng-repeat="allows in employee.dependents track by $index">
                                <td>{{allows.dependent_full_name}}</td>
                                <td>{{allows.dependent_relationship}}</td>
                                <td>{{allows.dependent_birth_date | date:'MM/dd/yyyy'}}</td>
                                <td>{{allows.dependent_supporting_document}}</td>
                                <td><button ng-click="del_dependent($index)" style="background-color:#323232; color:#fff;"><b>Delete</b></button></td>
                            </tr>
                        </tbody>
                    </table>
                <table class="tblemployees" width="100%">
                    <tr>
                        <td style ="background-color:#28ad1f;border-bottom:2px solid #fff;height:40px;font-size:25px;font-family:muli;color:#fff;"><b>Loan</b></td>
                    </tr>
                </table>
                <table class="tblemployees1" width="100%" >
                    <tr>
                        <td>
                            <label style="display:block; float:left; padding-top:10px; padding-right:1px;width:60%;font-size:15px; color:#fff;font-family:muli;">With Loan</label>
                        </td> 
                        <td >
                            <input required ng-model="employee.loan_status" title="Please check this box if you want to put a loan" type="checkbox" style="display: block; float: left; width: 40px;height:40px;"/>
                        </td>
    
                    </tr>
                </table>
                <table class="tblemployees1" width="100%" > 
                    <tr ng-show="employee.loan_status">
                        <td>
                            <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:100px; border:0px;color:#fff;font-family:muli;">Loan Type:</label>
                        </td>
                        <td id="css">
                            <select ng-model="loan_type" style="display: block; float: left; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px; border:0px; solid #f0f0f0;  margin-right: 10px; width:310px;" >
                                <option value="" disabled selected style="display:none"> -- Select from the options -- </option>
                                <option ng-repeat="(k, v) in loan_types.data" style="cursor:pointer;" value="{{v.type}}">
                                    {{v.type}}
                                </option>
                            </select>
                        </td> 
                             <td id="css">
                            <select ng-model="payout_type" style="display: block; float: left; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px; border:0px; solid #f0f0f0;  margin-right: 10px; width:310px;" >
                                <option value="" disabled selected style="display:none"> -- Select from the options -- </option>
                                <option value="Once a month (1st Payout)"> Once a month (1st Payout)</option>
                                <option value="Once a month (2nd Payout)"> Once a month (2nd Payout)</option>
                                <option value="Whole Payout"> Whole Payout</option>
                                <option value="Twice a month"> Twice a month</option>
                            </select>
                     
                        </td>
                        <td></td>
                    </tr>
                    <tr ng-show="employee.loan_status">
                        <td>
                            <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:100px; border:0px;color:#fff;font-family:muli;">Date Issued:</label>
                        </td>
                        <td id="css">
                            <input ng-show="show_regular" name="inputk" ng-model="loan_date_issued" type="date"  style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;"/>
                        </td>

                        <td>
                            <label style="display: block; float: left; width:310px; height:40px; color:#fff; font-family: muli; border-radius: 7px; padding: 5px;">Salary Deduction<br>Start In:</label>
                        </td>
                        <td id="css">
                            <select ng-model="loan_start_in_month" style="display: block; float: left; width:150px; height:36px;" >
                                <option value="" disabled selected style="display:none"> Month</option>
                                <option value="January">January</option>
                                <option value="February">February</option>
                                <option value="March">March</option>
                                <option value="April">April</option>
                                <option value="May">May</option>
                                <option value="June">June</option>
                                <option value="July">July</option>
                                <option value="August">August</option>
                                <option value="September">September</option>
                                <option value="October">October</option>
                                <option value="November">November</option>
                                <option value="December">December</option>
                            </select>
                            <input ng-model="loan_start_in_year" type="textarea" style="display: block; float: left; width:100px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;" placeholder="Year" maxlength = "4" is-number/>
                        </td>
                    </tr>

                    <tr ng-show="employee.loan_status">
                        <td>
                            <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:100px; border:0px; color:#fff; font-family: muli;">Amount:</label>
                        </td>
                        <td id="css">
                            <input ng-model="loan_amount" type = "text" is-number style="display: block; float: left;  height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;border:0px; solid #f0f0f0;  margin-right: 10px; width:300px;" required/>
                            &nbsp
                        </td>
                        <td>
                            <label style="display: block; float: left; width:310px; height:40px; color:#fff; font-family: muli; border-radius: 7px; padding: 5px;">Monthly Amortization:</label>
                        </td>
                        <td>
                            <input name="amortization" required ng-model="amortization" type = "text" is-number style="display: block; float: left; width:170px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;"/>
                            <button type="button" ng-click="add_loan()" class="large button white" style="width:170px;">+ Add Loan</button>
                        </td>
                    </tr>
                </table>
                <table class="tblemployees table table-bordered table-striped" ng-show="employee.loan_status" style="width:100%;" >
                        <thead>
                            <tr>
                                <th>Loan Type</th>
                                <th>Date Issued</th>
                                <th>Salary Deduction<br>Start In</th>
                                <th>Amount</th> 
                                <th>Deduction Schedule</th>
                                <th>Monthly Amortization</th>
                                <th>Option</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr ng-repeat="allow in employee.loans track by $index">
                                <td>{{allow.loan_type}}</td> 
                                <td>{{allow.loan_date_issued}}</td>
                                <td>{{allow.loan_start_in_month}} {{allow.loan_start_in_year}}</td>
                                <td>{{allow.loan_amount}}</td>
                                <td>{{allow.payout_type}}</td>
                                <td>{{allow.loan_amortization}}</td>
                                <td><button ng-click="del_loans($index)" style="background-color:#323232; color:#fff;"><b>Delete</b></button></td>
                            </tr>
                        </tbody>
                    </table>
                    <table class="tblemployees" width="100%">
                        <tr>
                            <td style ="background-color:#28ad1f;border-bottom:2px solid #fff;height:40px;font-size:25px;font-family:muli;color:#fff;"><b>Paternity and Maternity Leave</b></td>
                        </tr>
                    </table>
                    <table class="tblemployees1" width="100%" >
                    <tr>
                        <td>
                            <label style="display:block; float:left; padding-top:10px; padding-right:1px;width:60%;font-size:15px;color:#fff;font-family:muli;">With Maternity and <br>Paternity Leave</label>
                        </td>
                        <td >
                            <input required ng-model="employee.leave_status" title="Please check this box if you want to put an Maternity and Paternity Value"type="checkbox" style="display: block; float: left; width: 40px;height:40px;"/>
                        </td>
    
                    </tr>
                </table>
                <table class="tblemployees1" width="100%" >
                    <tr ng-show="employee.leave_status">
                        <td>
                            <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:14px; width:100px; border:0px; color:#fff; font-family:muli;">Leave Type:</label>
                        </td>
                        <td id="css">
                            <select ng-model="leave_type" style="display: block; float: left; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px; border:0px; solid #f0f0f0;  margin-right: 10px; width:310px;" >
                                <option value="" disabled selected style="display:none"> -- Select from the options -- </option>
                                <option ng-repeat="(k, v) in get_leave_pm.data" style="cursor:pointer;" value="{{v.name}}">
                                    {{v.name}}
                                </option>
                            </select>
                        </td>
                        <td>
                            <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:100px; border:0px;color:#fff; font-family: muli;">Amount:</label>
                        </td>
                        <td id="css">
                            <input ng-model="leave_amount" type = "text" is-number style="display: block; float: left; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px; border:0px; solid #f0f0f0;  margin-right: 10px; width:300px; margin-top: -10px;" required/>
                            &nbsp;
                            <button type="button" ng-click="add_leave()" class="large button white" style="width:300px; margin-top: -10px;">+ Add Leave</button>
                        </td>
                    </tr>
                </table>
                <table class="tblemployees table table-bordered table-striped" ng-show="employee.leave_status" style="margin-top:-10px;width:100%" >
                        <thead>
                            <tr>
                                <th style="font-size:15px">Leave Type</th>
                                <th style="font-size:15px">Amount</th>
                                <th style="font-size:15px">Option</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr ng-repeat="allow in employee.leaves_pm track by $index">
                                <td>{{allow.leave_type}}</td>
                                <td>{{allow.leave_amount}}</td>
                                <td><button ng-click="del_leave($index)" style-"background-color:#323232; color:#fff;">Delete</button></td>
                            </tr>
                        </tbody>
                    </table>
                <table class="tblemployees" width="100%">
                    <tr>
                        <td style ="background-color:#28ad1f;color:#fff;border-bottom:2px solid #fff;height:40px;font-size:25px;font-family:muli;"><b>Previous Working Experience</b></td>
                    </tr>
                </table>
                <table class="tblemployees1" width="100%" >
                    <tr>
                        <td>
                            <label style="display:block; float:left; padding-top:10px; padding-right:1px;width:60%;font-size:15px;color:#fff;font-family:muli;">With Working <br>Experience?</label>
                        </td>
                        <td >
                            <input required ng-model="employee.work_status" title="Please check this box if you want to put an working experience"type="checkbox" style="display: block; float: left; width: 40px;height:40px;"/>
                        </td>
    
                    </tr>
                </table>
                <table class="tblemployees1" width="100%" ng-show="employee.work_status">
                    <tr>
                        <td>
                            <button type="button" ng-click="addNewChoice2()" class="large button white" style="margin-top:20px;width:250px;"  title="Add Only 3 Most Recent Working Experience">+ Add Working Experience</button>
                        </td>
                        <td colspan="2">
                            <button type="button" ng-click="removeChoice2()" class="large button white" style="margin-top:20px;width:250px;"  title="Add Only 3 Most Recent Working Experience">- Delete Working Experience</button>
                        </td>
                    </tr>
                </table>
                <table ng-show="employee.work_status" class="tblemployees" width="100%" ng-repeat="formw in employee.work_experience track by $index" ng-init="name = formw.type
                ">
                <tr>{{}}
                    <td style="background-color:#fff"><h4 style="display:block; float:left; padding-right:10px; font-size:25px; font-family: muli;border:0px;color:#323232;margin-top:1px; width:100%; border-bottom: 3px solid #28ad1f;" ><b>{{formw.type}}</b></h4></td>
                    <td style="background-color:#666666" colspan="3">
                </tr>
                <tr>
                    <td>
                        <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px border:0px;">Company Name:</label>
                    </td>
                    <td id="css">
                        <input name="seminar" required ng-model="formw.work_company" type="textarea" style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;"/>
                    </td>
                    <td>
                        <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px border:0px;">Position Title:</label>
                    </td>
                    <td id="css">
                        <input name="seminar" required ng-model="formw.work_position" type="textarea" style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;"/>
                    </td>
                </tr>
            
                <tr>
                    <td>
                        <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px border:0px;">Inclusive Date <br>From:</label>
                    </td>
                    <td id="css">
                        <select ng-model="formw.inclusive_from" style="display: block; float: left; width:150px; height:36px;" >
                            <option value="" disabled selected style="display:none"> Month</option>
                            <option value="January">January</option>
                            <option value="February">February</option>
                            <option value="March">March</option>
                            <option value="April">April</option>
                            <option value="May">May</option>
                            <option value="June">June</option>
                            <option value="July">July</option>
                            <option value="August">August</option>
                            <option value="September">September</option>
                            <option value="October">October</option>
                            <option value="November">November</option>
                            <option value="December">December</option>
                        </select>
                        <input ng-model="formw.inclusive_from_year" type="textarea" style="display: block; float: left; width:100px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px; margin-left:10px;" placeholder="Year" maxlength = "4" is-number/>
                    </td>
                    <td>
                        <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px border:0px;">Inclusive Date <br>To:</label>
                    </td>
                    <td id="css">
                        <select ng-model="formw.inclusive_to" style="display: block; float: left; width:150px; height:36px;" >
                            <option value="" disabled selected style="display:none"> Month</option>
                            <option value="January">January</option>
                            <option value="February">February</option>
                            <option value="March">March</option>
                            <option value="April">April</option>
                            <option value="May">May</option>
                            <option value="June">June</option>
                            <option value="July">July</option>
                            <option value="August">August</option>
                            <option value="September">September</option>
                            <option value="October">October</option>
                            <option value="November">November</option>
                            <option value="December">December</option>
                        </select>
                        <input ng-model="formw.inclusive_to_year" type="textarea" style="display: block; float: left; width:100px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px; margin-left:10px;" placeholder="Year" maxlength = "4" is-number/>
                    </td>
                </tr>
                <td>
                    <label style="display:block; float:left; padding-top:10px; padding-right:10px;font-size:15px">Responsibilities:</label>
                </td>
                <td id="css">
                    <textarea rows="7" cols="35" ng-model="formw.work_respon">
                    </textarea>
                </td>
                <td>
                    <label style="display:block; float:left; padding-top:10px; padding-right:10px;font-size:15px">Reason for <br>Leaving:</label>
                </td>
                <td id="css">
                    <textarea rows="7" cols="35" ng-model="formw.reason">
                    </textarea>
                </td>
            </tr>
        </table>
          <table class="tblemployees" width="100%">
                    <tr>
                        <td style ="background-color:#28ad1f; color:#fff;border-bottom:2px solid #fff;height:40px;font-size:25px;font-family:muli; "><b>Cloud 201 Files</b></td>
                    </tr> 
                    <tr>
                <td>
                <div style="margin-top:0px;background-color:#666666; margin-bottom:0px;">
                        <input type="file" style="margin-left:10px;" nv-file-select="" uploader="uploader_dependent" />
                    <span style="display: block; margin-left:10px; font-family: muli; border-radius: 7px; padding: 5px;"> 
                    Document Name:
                    </span>
                    <input name="seminar" required ng-model="document_name" type="textarea" style="display: block; margin-left:10px; width:150px; height:25px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;"/>
                    <button type="button" style="margin-left:10px; margin-top:8px;" class="btn btn-success btn-s" ng-click="uploader_dependent.uploadAll();">
                        <span  class="glyphicon glyphicon-upload"></span> Upload
                    </button>
                    <button type="button" style="margin-top:8px;"class="btn btn-warning btn-s" ng-click="uploader_dependent.cancelAll()">
                        <span class="glyphicon glyphicon-ban-circle" ></span> Cancel 
                    </button>
                    <div style="width:200px; margin-left:10px;">
                        Upload progress:
                        <div class="progress" style="">
                            <div class="progress-bar" role="progressbar" ng-style="{ 'width': uploader_dependent.progress + '%' }">
                            </div>
                    </div>
                    <button type="button" style="margin-left:10px; margin-top:8px;" class="btn btn-success btn-s" ng-click="add_document();" ng-disabled = 'addDocuDisabled'>
                        <span class="glyphicon glyphicon-ban-plus" ></span> + Add Document 
                    </button>
                </td>
                </tr>
                </div>
</table>
<table class="tblemployees" width="100%">
    <tbody>
        <tr>
        <td><strong>Document Name</strong></td>
        <td><strong>Date Uploaded</strong></td>
        <td><strong>Download</strong></td>
        </tr>
        <tr ng-repeat="(hi,ji) in employee.documents track by $index">
            <td>
                {{ji.document_name}}
            </td>
            <td>
                {{ji.document_date_created}}
            </td>
            <td>
                <a download = "{{ ji.document_name }}" href="{{ji.document_supporting_document}}" target="_blank"> Download File
                <!-- <img src="{{ji.document_supporting_document}}" style="height:160px; width: 160px;border-radius: 13px;"> -->
                </a>
            </td>
        </tr>
    </tbody>
</table>

        <table class="tblemployees" width="100%">
            <tr>
                <td style ="background-color: #28ad1f;color:#fff;border-bottom:2px solid #fff;height:40px;font-size:25px;"><b>Trainings and Seminar</b></td>
            </tr>
        </table>
        <table class="tblemployees" width="100%">
            <tr>
                <td>
                    <label style="display:block; float:left; padding-top:10px; padding-right:1px;width:200px;font-size:15px">With Training and Seminar?</label>
                </td>
                <td id="css">
                    <input ng-model="employee.train_seminar" title="Please check this box if you want to put training and seminar details"type="checkbox" style="display: block; float: left; width: 40px;height:40px;"/>
                </td>
                <td>
                </td>
            </tr>
        </table>
    <table ng-show="employee.train_seminar" class="tblemployees" width="100%" ng-repeat="forms in employee.seminar_trainings track by $index" ng-init="name = forms.type
        ">
        <tr>
            <td colspan="4"><h4 style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:18px; width:120px border:0px; font-family: muli;" ><b>{{forms.type}}</b></h4></td>
        </tr>
        <tr>
            <td>
                <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px border:0px;">Name:</label>
            </td>
            <td id="css">
                <input name="seminar" required ng-model="forms.seminar_type" type="textarea" style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;"/>
            </td>
            <td>
                <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px border:0px;">Location:</label>
            </td>
            <td id="css">
                <input name="seminar" required ng-model="forms.seminar_locations" type="textarea" style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;"/>
            </td>
        </tr>
        <tr>
            <td>
                <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:15px; width:120px border:0px;">Date :</label>
            </td>
            <td id="css">
                <select ng-model="forms.seminar_date" style="display: block; float: left; width:150px; height:36px;" >
                            <option value="" disabled selected style="display:none"> Month</option>
                            <option value="January">January</option>
                            <option value="February">February</option>
                            <option value="March">March</option>
                            <option value="April">April</option>
                            <option value="May">May</option>
                            <option value="June">June</option>
                            <option value="July">July</option>
                            <option value="August">August</option>
                            <option value="September">September</option>
                            <option value="October">October</option>
                            <option value="November">November</option>
                            <option value="December">December</option>
                        </select>
                        <input ng-model="forms.seminar_date_year" type="textarea" style="display: block; float: left; width:100px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px; margin-left:10px;" placeholder="Year" maxlength = "4" is-number/>
            </td>
            <td>
                <div>
                    <input type="image" src="./ASSETS/img/delete_with_circle.png" title="Remove" s ng-click="removeChoice1($index)" title="Remove">
                </div>
            </td>
            <td></td>
        </tr>
    </table>
    <table class="tblemployees" ng-show="employee.train_seminar" width="100%">
        <tr>
            <td >
                <select required ng-model="employee.seminar" style="display: block; float: right; width:300px;padding:5px;margin-top:20px;" >
                    <option value="" disabled selected style="display:none"> -- Select from the options -- </option>
                    <option value="1">Seminar</option>
                    <option value="2">Training</option>
                </select>
            </td>
            <td>
                <button type="button" ng-click="addNewChoice1()" class="large button white" style="margin-top:20px; float: right;" >+ Add Seminar / Training</button>
            </td>
        </tr>
    </table>
    <table class="tblemployees" width="100%">
        <tr>
            <td style ="background-color: #28ad1f;color:#fff;border-bottom:2px solid #fff;height:40px;font-family: muli;font-size:25px;"><b>Work Days</b></td>
        </tr>
    </table>
    <table class="tblemployees" width="100%">
    <tr>
        <td style="width:10%">
            <label style="display:block; float:left; padding-top:10px; padding-right:10px;font-size:14px;color: white;">Sunday:</label>
        </td>
        <td>
            <input type="checkbox" ng-model="employee.work_days_status.sun" style="display: block; float: left; width:20px; height:34px;" />
        </td>
        <td style="width:10%">
            <label style="display:block; float:left; padding-top:10px; padding-right:10px;font-size:14px;color: white;">Monday:</label>
        </td>
        <td>
            <input type="checkbox" ng-model="employee.work_days_status.mon" style="display: block; float: left; width:20px; height:34px;" />
        </td>
    </tr>
    <tr>
        <td style="width:10%">
            <label style="display:block; float:left; padding-top:10px; padding-right:10px;font-size:14px;color: white;">Tuesday:</label>
        </td>
        <td>
            <input type="checkbox" ng-model="employee.work_days_status.tue" style="display: block; float: left; width:20px; height:34px;" />
        </td>
        <td style="width:10%">
            <label style="display:block; float:left; padding-top:10px; padding-right:10px;font-size:14px;color: white;">Wednesday:</label>
        </td>
        <td>
            <input type="checkbox" ng-model="employee.work_days_status.wed" style="display: block; float: left; width:20px; height:34px;" />
        </td>
    </tr>
    <tr>
        <td style="width:10%">
            <label style="display:block; float:left; padding-top:10px; padding-right:10px;font-size:14px;color: white;">Thursday:</label>
        </td>
        <td>
            <input type="checkbox" ng-model="employee.work_days_status.thu" style="display: block; float: left; width:20px; height:34px;" />
        </td>
        <td style="width:10%">
            <label style="display:block; float:left; padding-top:10px; padding-right:10px;font-size:14px;color: white;">Friday:</label>
        </td>
        <td>
            <input type="checkbox" ng-model="employee.work_days_status.fri" style="display: block; float: left; width:20px; height:34px;" />
        </td>
    </tr>
    <tr>
        <td style="width:10%">
            <label style="display:block; float:left; padding-top:10px; padding-right:10px;font-size:14px;color: white;">Saturday:</label>
        </td>
        <td>
            <input type="checkbox" ng-model="employee.work_days_status.sat" style="display: block; float: left; width:20px; height:34px;" />
        </td>
        <td></td>
        <td></td>
    </tr>
    <tr>
        <td colspan = "3">
            <center style="font-size: 18px; font-style: bold">
                <button type="button" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-secondary" data-ng-click="confirm(1)">{{modal.close}}</button>
                <button type="submit" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-primary" data-ng-click="closeThisDialog('Save')" style="background-color: black">{{modal.save}}</button>
    
            </center>
        </td>
        <td></td>
    </tr>
    </table>
    </div>
    <div ng-if="tab.compensation">
        <table class="tblemployees" width="100%" ng-if="compensation_status">
            <tr>
                <td>
                    <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:14px; width:290px  ; border:0px solid #f0f0f0;">Monthly Base Rate:</label>
                </td>
                <td id="css">
                    <input name="ma_mount" required ng-model="employee.monthly_amount" type = "textarea" is-number style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;" />
                    <span style="color:red;display: block; float: left; width:310px;" ng-show="myForm.ma_mount.$error.required">Amount is required.</span>
                </td>
            </tr>
            <!-- <tr>
                <td>
                    <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:14px; width:290px  ; border:0px solid #f0f0f0;">Weekly Base Rate:</label>
                </td>
                <td id="css">
                    <input name="wa_mount" required ng-model="employee.weekly_amount" type = "textarea" is-number style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;" />
                    <span style="color:red;display: block; float: left; width:310px;" ng-show="myForm.wa_mount.$error.required">Amount is required.</span>
                </td>
            </tr> -->
            <tr>
                <td>
                    <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:14px; width:290px  ; border:0px solid #f0f0f0;">Daily Base Rate:</label>
                </td>
                <td id="css">
                    <input name="a_mount" required ng-model="employee.amount" type = "textarea" is-number style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;" />
                    <span style="color:red;display: block; float: left; width:310px;" ng-show="myForm.a_mount.$error.required">Amount is required.</span>
                </td>
            </tr>
            <tr>
                <td>
                    <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:14px; width:290px  ; border:0px solid #f0f0f0;">Hourly Base Rate:</label>
                </td>
                <td id="css">
                    <input name="ha_mount" required ng-model="employee.hourly_amount" type = "textarea" is-number style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;" />
                    <span style="color:red;display: block; float: left; width:310px;" ng-show="myForm.ha_mount.$error.required">Amount is required.</span>
                </td>
            </tr>
            <tr>
                <td>
                    <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:14px; width:290px  ; border:0px solid #f0f0f0;">Monthly Allowance:</label>
                </td>
                <td id="css">
                    <input name="aa_mount" required ng-model="employee.mnontax_allowance" type = "textarea" is-number style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;" />
                    <span style="color:red;display: block; float: left; width:310px;" ng-show="myForm.aa_mount.$error.required">Amount is required.</span>
                </td>
            </tr>
            <!-- <tr>
                <td>
                    <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:14px; width:290px  ; border:0px solid #f0f0f0;">Weekly Allowance:</label>
                </td>
                <td id="css">
                    <input name="ba_mount" required ng-model="employee.wnontax_allowance" type = "textarea" is-number style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;" />
                    <span style="color:red;display: block; float: left; width:310px;" ng-show="myForm.ba_mount.$error.required">Amount is required.</span>
                </td>
            </tr> -->
            <tr>
                <td>
                    <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:14px; width:290px  ; border:0px solid #f0f0f0;">Daily Allowance:</label>
                </td>
                <td id="css">
                    <input name="ca_mount" required ng-model="employee.dnontax_allowance" type = "textarea" is-number style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;" />
                    <span style="color:red;display: block; float: left; width:310px;" ng-show="myForm.ca_mount.$error.required">Amount is required.</span>
                </td>
            </tr>
            <!-- <tr>
                <td>
                    <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:14px; width:290px  ; border:0px solid #f0f0f0;">Daily Taxable Allowance:</label>
                </td>
                <td id="css">
                    <input name="da_mount" required ng-model="employee.dtax_allowance" type = "textarea" is-number style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;" />
                    <span style="color:red;display: block; float: left; width:310px;" ng-show="myForm.da_mount.$error.required">Amount is required.</span>
                </td>
            </tr> -->
            <tr>
                <td>
                    <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:14px; width:290px  ; border:0px solid #f0f0f0;">Hourly Allowance:</label>
                </td>
                <td id="css">
                    <input name="fa_mount" required ng-model="employee.hnontax_allowance" type = "textarea" is-number style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;" />
                    <span style="color:red;display: block; float: left; width:310px;" ng-show="myForm.fa_mount.$error.required">Amount is required.</span>
                </td>
            </tr>
            <!-- <tr>
                <td>
                    <label style="display:block; float:left; padding-top:10px; padding-right:10px; font-size:14px; width:290px  ; border:0px solid #f0f0f0;">Hourly Taxable Allowance:</label>
                </td>
                <td id="css">
                    <input name="qa_mount" required ng-model="employee.htax_allowance" type = "textarea" is-number style="display: block; float: left; width:310px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;" />
                    <span style="color:red;display: block; float: left; width:310px;" ng-show="myForm.qa_mount.$error.required">Amount is required.</span>
                </td>
            </tr> -->
            <tr>
            <td colspan = "1">
                <center style="font-size: 18px; font-style: bold">
                    <button type="button" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-secondary" data-ng-click="confirm(1)">{{modal.close}}</button>
                    <button type="submit" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-primary" data-ng-click="closeThisDialog('Save')" style="background-color: black">{{modal.save}}</button>
    
                </center>
            </td>
            <td></td>
        </tr>
        </table>
        <class="tblemployees" width="100%" ng-if="!compensation_status">
            <tr>
                <td>
                    <img src="./ASSETS/img/access-denied.jpg" class="img-responsive">
                </td>
            </tr>
            <tr>
                <td colspan = "1">
                    <center style="font-size: 18px; font-style: bold">
                        <button type="button" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-secondary" data-ng-click="confirm(1)">{{modal.close}}</button>
                    </center>
                </td>
            </tr>
        </table>
    </div>
    <div ng-if="tab.government">

<!--John Dee-->    
        <table class="tblemployees" ng-repeat="id in employee.government track by $index" ng-init="name = id.idType" width="100%">
            <tr>
                <td><h4 style="display:block; float:left;padding-right:10px; font-size:17px; font-family: muli; width:100%; border:0px solid #f0f0f0;" ><div class ="labelbck">{{id.idType}}</div></h4></td>
                <td>
                    <input type="image" src="./ASSETS/img/delete_with_circle.png" ng-click="removeId($index)" title="Remove Education" style="width:36px; height:40px; padding-top:6px;">
                </td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
            </tr>
            <tr>
                <td>
                    <label style="display:block; float:left; padding-top:10px; padding-right:5px; font-size:15px; width:100px  ; border:0px solid #f0f0f0;">Type of Govt ID:</label>
                </td>
                <td id="css">
                <input required ng-model="id.idType" type = "text"  style="display: block; float: left; width:200px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;" />
                </td>
                <td>
                    <label style="display:block; float:left; padding-top:10px; padding-right:5px; font-size:14px; width:100px ; border:0px solid #f0f0f0;"> Number:</label>
                </td>
                <td id="css">
                    <input required ng-model="id.idNumber" type = "text" style="display: block; float: left; width:200px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;" />
                </td>
                <td>
                    <label style="display:block; float:left; padding-top:10px; padding-right:5px; font-size:14px; width:100px ; border:0px solid #f0f0f0;"> Expiration:</label>
                </td>
                <td id="css">
                    <input onfocus="(this.type='date')" required ng-model="id.idExp" type = "text" style="display: block; float: left; width:200px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;" />
                </td>
            </tr>
        </table>

        <table class="tblemployees" width="100%">
            <tr>
                <td colspan = "4">
                    <center style="font-size: 18px; font-style: bold">
                        <button type="button" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-secondary" data-ng-click="confirm(1)">{{modal.close}}</button>
                        <button type="submit" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-primary" data-ng-click="closeThisDialog('Save')" style="background-color: black">{{modal.save}}</button>
                        <button type="button" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-primary" data-ng-click="addIdType()">+Add New ID</button>
                    </center>
                </td>
            </tr>
        </table>
<!--End-->

    </div>
    </form>
    </div>
    </div>
    </div>
    
    
    </script>

    <script type="text/ng-template" id="ApplyModal">
        <div class="row">
            <div class="col-md-12 col-sm-12 col-lg-12">
                <div style="width: 100%" align="center">
                    <img src="ASSETS/img/logo_black_white.png" style="height: 45px;"/>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12 col-sm-12 col-lg-12">
                <hr/>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12 col-sm-12 col-lg-12">
                <h3><span style="color:#fff;">{{ modal_remarks.title }}</span></h3>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12 col-sm-12 col-lg-12">
                    <p style="font-family: muli; color: #fff; font-weight: bold;">Are you sure you want to apply changes to this employee account?</p>
                    <p style="font-family: muli; color: #fff; font-weight: bold;">If yes, please input your reason for editing.</p>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12 col-sm-12 col-lg-12">
                    <textarea rows="10" class="form-control" ng-model="modal_remarks.remarks"></textarea>
            </div>
        </div>
        <div class="row" style="margin-top:10px;">
            <div class="col-md-12 col-sm-12 col-lg-12">
                <div class="ngdialog-buttons">
                    <button type="button" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-secondary" data-ng-click="closeThisDialog(0)">{{modal.close}}</button>
                    <button type="button" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-primary" data-ng-click="confirm(1)">{{modal.save}}</button>
                </div>
            </div>
        </div>
    </script>

    <script type="text/ng-template" id="DeleteModal">
        <div style="width: 100%" align="center">
                <img src="ASSETS/img/logo_black_white.png" style="height: 45px;">
        </div>
        <hr style="margin-top: -2px;">
       <div><center><b><p style="font-size: 15px;font-family: muli; color: #fff;">You have successfully applied changes to this employee account.</p></b></center></div>
       <div style="margin-top:-10px">
    
         <input type="button" value = "OK" style="background-color: #111111; color: #fff; border-radius: 5px; margin-top:-10px;" class="ngdialog-button ngdialog-button-primary" data-ng-click="closeThisDialog('Save')"></button></div>
    </script>
    <script type="text/ng-template" id="email_reminderModal" class="ngdialog-buttons">
        <div class="ngdialog-message" style="width: 100%;">
            <div style="margin-top: -5px; width: 50%; float: left;">
                <h3><span style="font-family: muli; color: #fff; margin-left:25px; margin-top: -20px;"><b>{{ modal.title }}</b></span></h3>

            </div><br/><br/><br/>
            <div class="row">
                <div style="padding-left: 80px; padding-right: 80px;">
                Step 1: Choose 2 email notification reminder dates and must not be on the day or after the actual regularization date of the employee.
                </div>
            </div> 
            <div class="row" style="padding-top:15px" >
                <div class="col-md-2 col-sm-2 col-lg-2"></div>
                <div class="col-md-4 col-sm-4 col-lg-4">
                    1st Notification Date
                    <input ng-show="show_regular" name="inputk" ng-model="employee.emaildatereminder1" max="{{modal.maxdate | date:'yyyy-MM-dd'}}" min="{{modal.mindate | date:'yyyy-MM-dd'}}" type="date"  style="display: block; float: left; width:200px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;"/>
                </div>
                <div class="col-md-4 col-sm-4 col-lg-4">
                    2nd Notification Date
                    <input ng-show="show_regular" name="inputk" ng-model="employee.emaildatereminder2" type="date" min="{{employee.emaildatereminder1 | date:'yyyy-MM-dd'}}" max="{{modal.maxdate | date:'yyyy-MM-dd'}}" style="display: block; float: left; width:200px; height:40px; color: #323232; font-family: muli; border-radius: 7px; padding: 5px;"/>
                </div>
            </div>
            <div class="row" style="padding-top:15px" >
                <div style="padding-left: 80px; padding-right: 80px;">
                    Step 2: Choose the names of HR staff who should be reminded about the regularization of the employee. (You can choose as many as you want). Note: No need to choose the immediate superior since he or she will be automatically notified by PANDAS via email.

                </div>
            </div> 
            <div class="row" style="padding-top:30px" >
                <div class="col-md-3 col-sm-3 col-lg-3"></div>
                <div style="float:left; margin-top: -17px;margin-left:-5px;margin-right:10px;">
                    <div 
                        isteven-multi-select
                        input-model="hremployee"
                        output-model="employee.hremployee"
                        button-label="icon name"
                        translation="localLang"
                        item-label="icon name maker"
                        tick-property="ticked"
                        style="width:375px; float:left;"
                        max-height="200px">
                            
                    </div>    <br/>
                    
                </div>
            </div> 

            <div class="ngdialog-buttons" style="padding-right:30px ;">
                    <button type="button" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-primary" data-ng-click="confirm(1)">{{modal.save}}</button>
            </div>
        </div>
    </script>

    <script type="text/ng-template" id="ErrorDeleteModal">
    <div style="width: 100%" align="center">
                <img src="ASSETS/img/logo_black_white.png" style="height: 45px;">
            </div>
            <hr style="margin-top: -2px;">
       <div><center><b><p style="font-size: 15px;font-family: muli; color: #fff;">An error occured, unable to save changes, please try again.</p></b></center></div>
       <div>
    
         <input type="button" value = "OK" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-primary" data-ng-click="closeThisDialog('Save')"></button>
    </script>

    <script type="text/ng-template" id="ActivateModal">
    <div style="width: 100%" align="center">
                <img src="ASSETS/img/logo_black_white.png" style="height: 45px;">
            </div>
            <hr style="margin-top: -2px;">
       <div><center><b><p style="font-size: 15px;font-family: muli; color: #fff;">You have successfully Reactivated an employees account.</p></b></center></div>
       </br>
       <div>
    
         <input type="button" value = "OK" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-primary" data-ng-click="closeThisDialog('Save')"></button>
    </script>

    <script type="text/ng-template" id="ErrorActivateModal">
    <div style="width: 100%" align="center">
                <img src="ASSETS/img/logo_black_white.png" style="height: 45px;">
            </div>
            <hr style="margin-top: -2px;">
       <div><center><b><p style="font-size: 15px;font-family: muli; color: #fff;">An error occured, unable to save changes, please try again.</p></b></center></div>
       </br>
       <div>
    
         <input type="button" value = "OK" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-primary" data-ng-click="closeThisDialog('Save')"></button>
    </script>

    <script type="text/ng-template" id="FnameModal">
    <div style="width: 100%" align="center">
                <img src="ASSETS/img/logo_black_white.png" style="height: 45px;">
            </div>
            <hr style="margin-top: -2px;">
       <div><center><b><p style="font-size: 15px;font-family: muli; color: #fff;">Please review the form. All fields with message below in red are required.</p></b></center></div>
       </br>
       <div>
    
         <input type="button" value = "OK" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-primary" data-ng-click="closeThisDialog('Save')"></button>
    </script>
    <script type="text/ng-template" id="MnameModal">
    <div style="width: 100%" align="center">
                <img src="ASSETS/img/logo_black_white.png" style="height: 45px;">
            </div>
            <hr style="margin-top: -2px;">
       <div><center><b><p style="font-size: 15px;font-family: muli; color: #fff;">Please review the form. All fields with message below in red are required.</p></b></center></div>
       <div>
    
         <input type="button" value = "OK" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-primary" data-ng-click="closeThisDialog('Save')"></button>
    </script>

    <script type="text/ng-template" id="Main">
    <div style="width: 100%" align="center">
                <img src="ASSETS/img/logo_black_white.png" style="height: 45px;">
            </div>
            <hr style="margin-top: -2px;">
       <div><center><b><p style="font-size: 15px;font-family: muli; color: #fff;">Please review the form. All fields with message below in red are required.</p></b></center></div>
       <div>
    
         <input type="button" value = "OK" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-primary" data-ng-click="closeThisDialog('Save')"></button>
    </script>

    <script type="text/ng-template" id="EmailModal">
    <div style="width: 100%" align="center">
                <img src="ASSETS/img/logo_black_white.png" style="height: 45px;">
            </div>
            <hr style="margin-top: -2px;">
       <div><center><b><p style="font-size: 15px;font-family: muli; color: #fff;">Please review the form. All fields with message below in red are required.</p></b></center></div>
       </br>
       <div>
    
         <input type="button" value = "OK" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-primary" data-ng-click="closeThisDialog('Save')"></button>
    </script>

    <script type="text/ng-template" id="GenderModal">
    <div style="width: 100%" align="center">
                <img src="ASSETS/img/logo_black_white.png" style="height: 45px;">
            </div>
            <hr style="margin-top: -2px;">
       <div><center><b><p style="font-size: 15px;font-family: muli; color: #fff;">Please review the form. All fields with message below in red are required.</p></b></center></div>
       </br>
       <div>
    
         <input type="button" value = "OK" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-primary" data-ng-click="closeThisDialog('Save')"></button>
    </script>

    <script type="text/ng-template" id="ReligionModal">
    <div style="width: 100%" align="center">
                <img src="ASSETS/img/logo_black_white.png" style="height: 45px;">
            </div>
            <hr style="margin-top: -2px;">
       <div><center><b><p style="font-size: 15px;font-family: muli; color: #fff;">Please review the form. All fields with message below in red are required.</p></b></center></div>
       </br>
       <div>
    
         <input type="button" value = "OK" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-primary" data-ng-click="closeThisDialog('Save')"></button>
    </script>

    <script type="text/ng-template" id="StatusModal">
    <div style="width: 100%" align="center">
                <img src="ASSETS/img/logo_black_white.png" style="height: 45px;">
            </div>
            <hr style="margin-top: -2px;">
       <div><center><b><p style="font-size: 15px;font-family: muli; color: #fff;">Please review the form. All fields with message below in red are required.</p></b></center></div>
       </br>
       <div>
    
         <input type="button" value = "OK" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-primary" data-ng-click="closeThisDialog('Save')"></button>
    </script>

    <script type="text/ng-template" id="IDModal">
    <div style="width: 100%" align="center">
                <img src="ASSETS/img/logo_black_white.png" style="height: 45px;">
            </div>
            <hr style="margin-top: -2px;">
       <div><center><b><p style="font-size: 15px;font-family: muli; color: #fff;">Please review the form. All fields with message below in red are required.</p></b></center></div>
       </br>
       <div>
    
         <input type="button" value = "OK" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-primary" data-ng-click="closeThisDialog('Save')"></button>
    </script>

    <script type="text/ng-template" id="StartedModal">
    <div style="width: 100%" align="center">
                <img src="ASSETS/img/logo_black_white.png" style="height: 45px;">
            </div>
            <hr style="margin-top: -2px;">
       <div><center><b><p style="font-size: 15px;font-family: muli; color: #fff;">Please review the form. All fields with message below in red are required.</p></b></center></div>
       </br>
       <div>
    
         <input type="button" value = "OK" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-primary" data-ng-click="closeThisDialog('Save')"></button>
    </script>

    <script type="text/ng-template" id="EAddModal">
    <div style="width: 100%" align="center">
                <img src="ASSETS/img/logo_black_white.png" style="height: 45px;">
            </div>
            <hr style="margin-top: -2px;">
       <div><center><b><p style="font-size: 15px;font-family: muli; color: #fff;">Please review the form. All fields with message below in red are required.</p></b></center></div>
       </br>
       <div>
    
         <input type="button" value = "OK" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-primary" data-ng-click="closeThisDialog('Save')"></button>
    </script>

    <script type="text/ng-template" id="BDayModal">
    <div style="width: 100%" align="center">
                <img src="ASSETS/img/logo_black_white.png" style="height: 45px;">
            </div>
            <hr style="margin-top: -2px;">
       <div><center><b><p style="font-size: 15px;font-family: muli; color: #fff;">Please review the form. All fields with message below in red are required.</p></b></center></div>
       </br>
       <div>
    
         <input type="button" value = "OK" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-primary" data-ng-click="closeThisDialog('Save')"></button>
    </script>

    <script type="text/ng-template" id="TitlessModal">
    <div style="width: 100%" align="center">
                <img src="ASSETS/img/logo_black_white.png" style="height: 45px;">
            </div>
            <hr style="margin-top: -2px;">
       <div><center><b><p style="font-size: 15px;font-family: muli; color: #fff;">Please review the form. All fields with message below in red are required.</p></b></center></div>
       </br>
       <div>
    
         <input type="button" value = "OK" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-primary" data-ng-click="closeThisDialog('Save')"></button>
    </script>

    <script type="text/ng-template" id="LevelsModal">
    <div style="width: 100%" align="center">
                <img src="ASSETS/img/logo_black_white.png" style="height: 45px;">
            </div>
            <hr style="margin-top: -2px;">
       <div><center><b><p style="font-size: 15px;font-family: muli; color: #fff;">Please review the form. All fields with message below in red are required.</p></b></center></div>
       </br>
       <div>
    
         <input type="button" value = "OK" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-primary" data-ng-click="closeThisDialog('Save')"></button>
    </script>

    <script type="text/ng-template" id="SuperVisorModal">
    <div style="width: 100%" align="center">
                <img src="ASSETS/img/logo_black_white.png" style="height: 45px;">
            </div>
            <hr style="margin-top: -2px;">
       <div><center><b><p style="font-size: 15px;font-family: muli; color: #fff;">Please review the form. All fields with message below in red are required.</p></b></center></div>
       </br>
       <div>
    
         <input type="button" value = "OK" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-primary" data-ng-click="closeThisDialog('Save')"></button>
    </script>

    <script type="text/ng-template" id="DepartmentModal">
    <div style="width: 100%" align="center">
                <img src="ASSETS/img/logo_black_white.png" style="height: 45px;">
            </div>
            <hr style="margin-top: -2px;">
       <div><center><b><p style="font-size: 15px;font-family: muli; color: #fff;">Please review the form. All fields with message below in red are required.</p></b></center></div>
       </br>
       <div>
    
         <input type="button" value = "OK" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-primary" data-ng-click="closeThisDialog('Save')"></button>
    </script>

    <script type="text/ng-template" id="EStatusModal">
    <div style="width: 100%" align="center">
                <img src="ASSETS/img/logo_black_white.png" style="height: 45px;">
            </div>
            <hr style="margin-top: -2px;">
       <div><center><b><p style="font-size: 15px;font-family: muli; color: #fff;">Please review the form. All fields with message below in red are required.</p></b></center></div>
       </br>
       <div>
    
         <input type="button" value = "OK" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-primary" data-ng-click="closeThisDialog('Save')"></button>
    </script>

    <script type="text/ng-template" id="ETypeModal">
    <div style="width: 100%" align="center">
                <img src="ASSETS/img/logo_black_white.png" style="height: 45px;">
            </div>
            <hr style="margin-top: -2px;">
       <div><center><b><p style="font-size: 15px;font-family: muli; color: #fff;">Please review the form. All fields with message below in red are required.</p></b></center></div>
       </br>
       <div>
    
         <input type="button" value = "OK" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-primary" data-ng-click="closeThisDialog('Save')"></button>
    </script>

    <script type="text/ng-template" id="PAddressModal">
    <div style="width: 100%" align="center">
                <img src="ASSETS/img/logo_black_white.png" style="height: 45px;">
            </div>
            <hr style="margin-top: -2px;">
       <div><center><b><p style="font-size: 15px;font-family: muli; color: #fff;">Please review the form. All fields with message below in red are required.</p></b></center></div>
       </br>
       <div>
    
         <input type="button" value = "OK" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-primary" data-ng-click="closeThisDialog('Save')"></button>
    </script>

    <script type="text/ng-template" id="PreAddressModal">
    <div style="width: 100%" align="center">
                <img src="ASSETS/img/logo_black_white.png" style="height: 45px;">
            </div>
            <hr style="margin-top: -2px;">
       <div><center><b><p style="font-size: 15px;font-family: muli; color: #fff;">Please review the form. All fields with message below in red are required.</p></b></center></div>
       </br>
       <div>
    
         <input type="button" value = "OK" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-primary" data-ng-click="closeThisDialog('Save')"></button>
    </script>

    <script type="text/ng-template" id="CNameModal">
    <div style="width: 100%" align="center">
                <img src="ASSETS/img/logo_black_white.png" style="height: 45px;">
            </div>
            <hr style="margin-top: -2px;">
       <div><center><b><p style="font-size: 15px;font-family: muli; color: #fff;">Please review the form. All fields with message below in red are required.</p></b></center></div>
       </br>
       <div>
    
         <input type="button" value = "OK" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-primary" data-ng-click="closeThisDialog('Save')"></button>
    </script>

    <script type="text/ng-template" id="ENoModal">
    <div style="width: 100%" align="center">
                <img src="ASSETS/img/logo_black_white.png" style="height: 45px;">
            </div>
            <hr style="margin-top: -2px;">
       <div><center><b><p style="font-size: 15px;font-family: muli; color: #fff;">Please review the form. All fields with message below in red are required.</p></b></center></div>
       </br>
       <div>
    
         <input type="button" value = "OK" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-primary" data-ng-click="closeThisDialog('Save')"></button>
    </script>

    <script type="text/ng-template" id="ENameModal">
    <div style="width: 100%" align="center">
                <img src="ASSETS/img/logo_black_white.png" style="height: 45px;">
            </div>
            <hr style="margin-top: -2px;">
       <div><center><b><p style="font-size: 15px;font-family: muli; color: #fff;">Please review the form. All fields with message below in red are required.</p></b></center></div>
       </br>
       <div>
    
         <input type="button" value = "OK" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-primary" data-ng-click="closeThisDialog('Save')"></button>
    </script>

    <script type="text/ng-template" id="ERalationModal">
    <div style="width: 100%" align="center">
                <img src="ASSETS/img/logo_black_white.png" style="height: 45px;">
            </div>
            <hr style="margin-top: -2px;">
       <div><center><b><p style="font-size: 15px;font-family: muli; color: #fff;">Please review the form. All fields with message below in red are required.</p></b></center></div>
       </br>
       <div>
    
         <input type="button" value = "OK" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-primary" data-ng-click="closeThisDialog('Save')"></button>
    </script>


    <script type="text/ng-template" id="ChangesModal">
    <div style="width: 100%" align="center">
                <img src="ASSETS/img/logo_black_white.png" style="height: 45px;">
            </div>
            <hr style="margin-top: -2px;">
       <div><center><b><p style="font-size: 15px;font-family: muli; color: #fff;">You have successfully applied changes to {{employee.first_name}} {{employee.last_name}}</p></b></center></div>
       </br>
       <div>
    
         <input type="button" value = "OK" style="background-color: #111111; color: #fff; border-radius: 5px; margin-top:-10px;" class="ngdialog-button ngdialog-button-primary" data-ng-click="closeThisDialog('Save')"></button> </div>
    </script>

    <script type="text/ng-template" id="ErrorChangesModal">
    <div style="width: 100%" align="center">
                <img src="ASSETS/img/logo_black_white.png" style="height: 45px;">
            </div>
            <hr style="margin-top: -2px;">
       <div><center><b><p style="font-size: 15px;font-family: muli; color: #fff;">An error occured, unable to save changes, please try again. </p></b></center></div>
       </br>
       <div>
    
         <input type="button" value = "OK" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-primary" data-ng-click="closeThisDialog('Save')"></button>
    </script>

    <script type="text/ng-template" id="PayrollTypeModal">
    <div style="width: 100%" align="center">
                <img src="ASSETS/img/logo_black_white.png" style="height: 45px;">
            </div>
            <hr style="margin-top: -2px;">
       <div><center><b><p style="font-size: 15px;font-family: muli; color: #fff;">The Payroll Type is activated 'None'. Please change first the Payroll Type and save it before inputting datas to Compensation details</p></b></center></div>
       </br>
       <div>
    
         <input type="button" value = "OK" style="background-color: #111111; color: #fff; margin-top:-30px; border-radius: 5px;" class="ngdialog-button ngdialog-button-primary" data-ng-click="closeThisDialog('Save')"></button>
    </script>

    <script type="text/ng-template" id="CompensationDetectorModal">
    <div style="width: 100%" align="center">
                <img src="ASSETS/img/logo_black_white.png" style="height: 45px;">
            </div>
            <hr style="margin-top: -2px;">
       <div><center><b><p style="font-size: 15px;font-family: muli; color: #fff;">It seems that you have no permission for the compensation details of this employee. Please take note that if you save any editted data from this employee will take an error action for the payroll. Only the permitted employees can edit this specific person. Please read the Compensation Details Policy under your company for strict compliance.</p></b></center></div>
       </br>
       <div>
    
         <input type="button" value = "OK" style="background-color: #111111; color: #fff; border-radius: 5px;" class="ngdialog-button ngdialog-button-primary" data-ng-click="closeThisDialog('Save')"></button>
    </script>





//////////////////////////////////////////////////////////////



<?php
$_id = md5('pk');

if(isset($_COOKIE[$_id]) && !empty($_COOKIE[$_id])){
	setcookie($_id, $_COOKIE[$_id], time()+7200000, '/');
	header("HTTP/1.0 200 OK");

	header('Content-Type: application/json');
	print(
			json_encode(
						array(
								$_id=>$_COOKIE[$_id]
							)
					)
		);
}
else{
	header("HTTP/1.0 404 No active session");
}


?>

///////////////////////////////////////////////////////////////////////




 <div id="box" data-aos="fade-up">
                        <div class="form-group">
                            <div class="cols-md-10">
                                <div class="input-group">
                                    <span class="input-group-addon"><i class="glyphicon glyphicon-user" aria-hidden="true"></i></span>
                                    <input type="text" class="form-control" name="name" id="employee_id"  placeholder="PANDAS User ID"/>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <div class="cols-md-10">
                                <div class="input-group">
                                    <span class="input-group-addon"><i class="glyphicon glyphicon-lock" aria-hidden="true"></i></span>
                                    <input type="password" class="form-control" name="name" id="employee_password"  placeholder="Password"/>
                                </div>
                            </div>
                        </div>

                        <p ng-controller="AccountRecovery" class="accRecov pull-left"><a id="AccountRecovery" ng-click="recover()">Account Recovery</a></p>

                        <div class="form-group ">
                            <button type="button" id="btn_submit" class="button" value="Log in" onclick="login()">Employee Login</button>
                        </div>

                        <div class="form-group">
                            <button type="button" id="btn_submit" class="button" value="Register"  onclick="register()">New Employee Registration</button>
                        </div>


                        <!-- <input type="text" id="employee_id" placeholder="Employee ID"/><br><br>
                        <input type="password" id="employee_password" placeholder="Password"/><br> -->
                        <!-- <button type="button" id="btn_submit" class="button" value="Log in" onclick="login()" style="background-color: black">Employee Login</button>
                        <button type="button" id="btn_submit" class="button" value="Register" onclick="register()" style="background-color: black;"> New Employee Registration</button> -->
                    </div>

                </form>
            </div>
<script type="text/javascript">
    

    
    function register(){
        window.location = window.location.href.replace('login.html','registration.html');
    }

</script>

<?php
require_once('../connect.php');
require_once('../../CLASSES/Employees.php');

$class = new Employees(
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL,
						NULL
					);

$data = $class->auth($_POST);

header("HTTP/1.0 404 User Not Found");
if($data['status']){
	$pk = md5('pk'); 
	setcookie($pk, md5($data['result'][0]['pk']), time()+7200000, '/');
	header("HTTP/1.0 200 OK");
}

header('Content-Type: application/json');
print(json_encode($data));
?>



